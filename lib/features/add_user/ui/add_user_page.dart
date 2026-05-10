import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_discovery/core/utils/extensions/context_ext.dart';
import 'package:movie_discovery/core/utils/validators.dart';
import 'package:movie_discovery/design_system/app_spacing.dart';
import 'package:movie_discovery/design_system/widgets/buttons/primary_button.dart';
import 'package:movie_discovery/features/add_user/logic/add_user_provider.dart';

class AddUserPage extends ConsumerStatefulWidget {
  const AddUserPage({super.key});

  @override
  ConsumerState<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends ConsumerState<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _tasteCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _tasteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addUserNotifierProvider);

    ref.listen(addUserNotifierProvider, (_, next) {
      next.whenOrNull(
        data: (_) {
          context.showSnackbar('User added!');
          context.pop();
        },
        error: (e, _) => context.showSnackbar(e.toString(), isError: true),
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('New User')),
      body: SingleChildScrollView(
        padding: AppSpacing.screen,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Alex',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => Validators.required(v, 'Name'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _tasteCtrl,
                decoration: const InputDecoration(
                  labelText: 'Movie Taste',
                  hintText: 'loves horror, no sad endings...',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => Validators.required(v, 'Movie taste'),
                maxLines: 2,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: 'Add User',
                isLoading: state.isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(addUserNotifierProvider.notifier).addUser(
            name: _nameCtrl.text.trim(),
            movieTaste: _tasteCtrl.text.trim(),
          );
    }
  }
}
