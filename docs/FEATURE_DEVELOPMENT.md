# 🚀 Feature Development Guide

## Step-by-Step: Adding a New Feature

This guide walks you through creating a complete feature following clean architecture principles.

## Example: Building a "Products" Feature

### Step 1: Create Folder Structure

```bash
mkdir -p lib/features/products/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{screens,widgets,providers}}
```

### Step 2: Define Domain Layer

#### 2.1 Create Entity

```dart
// lib/features/products/domain/entities/product_entity.dart
class ProductEntity {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  
  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}
```

#### 2.2 Create Repository Contract

```dart
// lib/features/products/domain/repositories/product_repository.dart
import 'package:flutter_app_template/core/network/result.dart';
import 'package:flutter_app_template/features/products/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<Result<List<ProductEntity>>> getProducts();
  Future<Result<ProductEntity>> getProductById(String id);
  Future<Result<ProductEntity>> createProduct(ProductEntity product);
  Future<Result<void>> deleteProduct(String id);
}
```

#### 2.3 Create Use Cases

```dart
// lib/features/products/domain/usecases/get_products_usecase.dart
import 'package:flutter_app_template/core/base/base_usecase.dart';
import 'package:flutter_app_template/core/network/result.dart';
import 'package:flutter_app_template/features/products/domain/entities/product_entity.dart';
import 'package:flutter_app_template/features/products/domain/repositories/product_repository.dart';

class GetProductsUseCase extends BaseUseCase<List<ProductEntity>, NoParams> {
  final ProductRepository repository;
  
  GetProductsUseCase(this.repository);
  
  @override
  Future<Result<List<ProductEntity>>> execute(NoParams params) {
    return repository.getProducts();
  }
}
```

```dart
// lib/features/products/domain/usecases/get_product_by_id_usecase.dart
import 'package:flutter_app_template/core/base/base_usecase.dart';
import 'package:flutter_app_template/core/network/result.dart';
import 'package:flutter_app_template/features/products/domain/entities/product_entity.dart';
import 'package:flutter_app_template/features/products/domain/repositories/product_repository.dart';

class GetProductByIdUseCase extends BaseUseCase<ProductEntity, String> {
  final ProductRepository repository;
  
  GetProductByIdUseCase(this.repository);
  
  @override
  Future<Result<ProductEntity>> execute(String id) {
    return repository.getProductById(id);
  }
}
```

### Step 3: Implement Data Layer

#### 3.1 Create DTO (Data Transfer Object)

```dart
// lib/features/products/data/models/product_dto.dart
import 'package:flutter_app_template/features/products/domain/entities/product_entity.dart';

class ProductDto {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  
  ProductDto({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
  
  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
    };
  }
  
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
    );
  }
  
  factory ProductDto.fromEntity(ProductEntity entity) {
    return ProductDto(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      imageUrl: entity.imageUrl,
    );
  }
}
```

#### 3.2 Create Data Source

```dart
// lib/features/products/data/datasources/product_remote_datasource.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app_template/core/constants/app_constants.dart';
import 'package:flutter_app_template/features/products/data/models/product_dto.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductDto>> getProducts();
  Future<ProductDto> getProductById(String id);
  Future<ProductDto> createProduct(ProductDto product);
  Future<void> deleteProduct(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  
  ProductRemoteDataSourceImpl(this.client);
  
  @override
  Future<List<ProductDto>> getProducts() async {
    final response = await client.get(
      Uri.parse('${ApiEndpoints.BASE_URL}/products'),
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ProductDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
  
  @override
  Future<ProductDto> getProductById(String id) async {
    final response = await client.get(
      Uri.parse('${ApiEndpoints.BASE_URL}/products/$id'),
    );
    
    if (response.statusCode == 200) {
      return ProductDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }
  
  @override
  Future<ProductDto> createProduct(ProductDto product) async {
    final response = await client.post(
      Uri.parse('${ApiEndpoints.BASE_URL}/products'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    
    if (response.statusCode == 201) {
      return ProductDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create product');
    }
  }
  
  @override
  Future<void> deleteProduct(String id) async {
    final response = await client.delete(
      Uri.parse('${ApiEndpoints.BASE_URL}/products/$id'),
    );
    
    if (response.statusCode != 204) {
      throw Exception('Failed to delete product');
    }
  }
}
```

#### 3.3 Implement Repository

```dart
// lib/features/products/data/repositories/product_repository_impl.dart
import 'package:flutter_app_template/core/errors/failures.dart';
import 'package:flutter_app_template/core/network/result.dart';
import 'package:flutter_app_template/features/products/data/datasources/product_remote_datasource.dart';
import 'package:flutter_app_template/features/products/data/models/product_dto.dart';
import 'package:flutter_app_template/features/products/domain/entities/product_entity.dart';
import 'package:flutter_app_template/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  
  ProductRepositoryImpl(this.remoteDataSource);
  
  @override
  Future<Result<List<ProductEntity>>> getProducts() async {
    try {
      final dtos = await remoteDataSource.getProducts();
      final entities = dtos.map((dto) => dto.toEntity()).toList();
      return Success(entities);
    } catch (e) {
      return Failure(ServerFailure('Failed to fetch products: $e'));
    }
  }
  
  @override
  Future<Result<ProductEntity>> getProductById(String id) async {
    try {
      final dto = await remoteDataSource.getProductById(id);
      return Success(dto.toEntity());
    } catch (e) {
      return Failure(ServerFailure('Failed to fetch product: $e'));
    }
  }
  
  @override
  Future<Result<ProductEntity>> createProduct(ProductEntity product) async {
    try {
      final dto = ProductDto.fromEntity(product);
      final createdDto = await remoteDataSource.createProduct(dto);
      return Success(createdDto.toEntity());
    } catch (e) {
      return Failure(ServerFailure('Failed to create product: $e'));
    }
  }
  
  @override
  Future<Result<void>> deleteProduct(String id) async {
    try {
      await remoteDataSource.deleteProduct(id);
      return const Success(null);
    } catch (e) {
      return Failure(ServerFailure('Failed to delete product: $e'));
    }
  }
}
```

### Step 4: Build Presentation Layer

#### 4.1 Create Products List Screen

```dart
// lib/features/products/presentation/screens/products_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_app_template/design_system/layouts/responsive_layout.dart';
import 'package:flutter_app_template/design_system/tokens/spacing.dart';
import 'package:flutter_app_template/shared/extensions/context_extensions.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
      ),
      body: ResponsiveLayout(
        mobile: _ProductsListView(),
        tablet: _ProductsGridView(crossAxisCount: 2),
        desktop: _ProductsGridView(crossAxisCount: 3),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add product screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ProductsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: AppSpacing.pagePadding,
      itemCount: 10, // Replace with actual data
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: Text('Product $index'),
            subtitle: Text('\$${(index + 1) * 10}.99'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to product details
            },
          ),
        );
      },
    );
  }
}

class _ProductsGridView extends StatelessWidget {
  final int crossAxisCount;
  
  const _ProductsGridView({required this.crossAxisCount});
  
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: AppSpacing.pagePadding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.75,
      ),
      itemCount: 10, // Replace with actual data
      itemBuilder: (context, index) {
        return Card(
          child: InkWell(
            onTap: () {
              // Navigate to product details
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    color: context.colors.surfaceVariant,
                    child: const Center(
                      child: Icon(Icons.shopping_bag, size: 48),
                    ),
                  ),
                ),
                Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product $index',
                        style: context.textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '\$${(index + 1) * 10}.99',
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

### Step 5: Wire Everything Together

#### 5.1 Create Dependency Injection (Manual)

```dart
// lib/features/products/products_dependencies.dart
import 'package:http/http.dart' as http;
import 'package:flutter_app_template/features/products/data/datasources/product_remote_datasource.dart';
import 'package:flutter_app_template/features/products/data/repositories/product_repository_impl.dart';
import 'package:flutter_app_template/features/products/domain/repositories/product_repository.dart';
import 'package:flutter_app_template/features/products/domain/usecases/get_products_usecase.dart';

class ProductsDependencies {
  static final http.Client _client = http.Client();
  
  static ProductRemoteDataSource get remoteDataSource =>
      ProductRemoteDataSourceImpl(_client);
  
  static ProductRepository get repository =>
      ProductRepositoryImpl(remoteDataSource);
  
  static GetProductsUseCase get getProductsUseCase =>
      GetProductsUseCase(repository);
}
```

## Testing Your Feature

### Unit Test: Use Case

```dart
// test/features/products/domain/usecases/get_products_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_app_template/core/base/base_usecase.dart';
import 'package:flutter_app_template/core/network/result.dart';
import 'package:flutter_app_template/features/products/domain/entities/product_entity.dart';
import 'package:flutter_app_template/features/products/domain/repositories/product_repository.dart';
import 'package:flutter_app_template/features/products/domain/usecases/get_products_usecase.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late GetProductsUseCase useCase;
  late MockProductRepository mockRepository;
  
  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetProductsUseCase(mockRepository);
  });
  
  test('should return list of products from repository', () async {
    // Arrange
    final testProducts = [
      const ProductEntity(
        id: '1',
        name: 'Test Product',
        description: 'Description',
        price: 9.99,
        imageUrl: 'https://example.com/image.jpg',
      ),
    ];
    when(() => mockRepository.getProducts())
        .thenAnswer((_) async => Success(testProducts));
    
    // Act
    final result = await useCase.execute(NoParams());
    
    // Assert
    expect(result, isA<Success<List<ProductEntity>>>());
    result.when(
      success: (products) => expect(products, testProducts),
      failure: (_) => fail('Should not fail'),
    );
    verify(() => mockRepository.getProducts()).called(1);
  });
}
```

### Widget Test: Screen

```dart
// test/features/products/presentation/screens/products_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_template/features/products/presentation/screens/products_screen.dart';

void main() {
  testWidgets('ProductsScreen displays correctly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProductsScreen(),
      ),
    );
    
    expect(find.text('Products'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
```

## Checklist

- [ ] Created folder structure
- [ ] Defined domain entities
- [ ] Created repository contract
- [ ] Implemented use cases
- [ ] Created DTOs
- [ ] Implemented data sources
- [ ] Implemented repository
- [ ] Built presentation screens
- [ ] Added dependency injection
- [ ] Wrote unit tests
- [ ] Wrote widget tests
- [ ] Updated navigation
- [ ] Documented feature

---

**Next Steps:**
- Add state management (Riverpod, Bloc, etc.)
- Add error handling UI
- Add loading states
- Add empty states
- Implement search/filter
- Add pagination
