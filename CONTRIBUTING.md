# Contributing to Flutter App Template

Thank you for your interest in contributing to this Flutter app template! This document provides guidelines and instructions for contributing.

## 🤝 How to Contribute

### Reporting Issues

If you find a bug or have a suggestion:

1. **Check existing issues** - See if it's already reported
2. **Create a new issue** - Use the appropriate template:
   - Bug Report: For bugs and errors
   - Feature Request: For new features or improvements
3. **Provide details** - Include:
   - Flutter version (`flutter --version`)
   - Platform (Android/iOS/Web/Desktop)
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots (if applicable)

### Suggesting Enhancements

We welcome ideas for improvements!

1. Open a Feature Request issue
2. Describe the enhancement in detail
3. Explain why it would be useful for the template
4. Provide examples if possible

### Pull Requests

#### Before You Start

1. Fork the repository
2. Create a new branch from `main`
3. Follow the coding standards below

#### Pull Request Process

1. **Update documentation** - If you change functionality, update README.md
2. **Test thoroughly** - Ensure your changes work on multiple platforms
3. **Follow conventions** - Match the existing code style
4. **Write clear commit messages** - Use conventional commits format
5. **Update CHANGELOG.md** - Add your changes under "Unreleased"

#### Commit Message Format

```
type(scope): subject

body (optional)

footer (optional)
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code formatting (no functional changes)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

Examples:
```
feat(theme): add dark mode support

fix(api): correct endpoint URL formation

docs(readme): update installation instructions
```

## 🎯 Development Guidelines

### Code Style

- **Follow Dart conventions** - Use `flutter format`
- **Use meaningful names** - Variables, functions, and classes should be descriptive
- **Add comments** - Document complex logic and public APIs
- **Keep it simple** - Avoid over-engineering

### File Organization

Maintain the clean architecture:
```
lib/
├── core/           # Infrastructure
├── design_system/  # UI components & tokens
├── shared/         # Shared utilities
├── features/       # Feature modules
└── app/            # App configuration
```

### Testing

While this template doesn't include tests by default, if you add testable features:

```bash
# Run tests
flutter test
```

### Documentation

- Update README.md for new features
- Add inline documentation for complex code
- Update TEMPLATE_SETUP.md if setup process changes

## 📝 Specific Contribution Areas

### High-Priority Contributions

We especially welcome contributions in these areas:

1. **Additional Utilities**
   - Form validators
   - Date/time formatters
   - Network connectivity helpers
   - Local storage helpers

2. **Example Implementations**
   - Authentication flows
   - CRUD operations
   - State management patterns
   - API integration examples

3. **Documentation**
   - Video tutorials
   - Blog posts
   - Translation to other languages
   - Better code examples

4. **Platform Support**
   - Web-specific optimizations
   - Desktop platform improvements
   - Platform-specific widgets

### Areas to Avoid

Please don't include:
- **Heavy dependencies** - Keep the template lightweight
- **Opinionated frameworks** - Let users choose their state management
- **Business logic** - This is a template, not a complete app
- **Large assets** - Keep repository size small

## 🔍 Code Review Process

1. **Automated checks** - CI will run Flutter analyzer and formatter
2. **Maintainer review** - A maintainer will review your PR
3. **Feedback** - Address any requested changes
4. **Merge** - Once approved, we'll merge your contribution

## 🌟 Recognition

Contributors will be:
- Listed in README.md (if significant contribution)
- Credited in release notes
- Given a shout-out on social media (optional)

## 📜 Code of Conduct

### Our Pledge

We pledge to make participation in this project a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, gender identity and expression, level of experience, nationality, personal appearance, race, religion, or sexual identity and orientation.

### Our Standards

**Positive behavior:**
- Using welcoming and inclusive language
- Being respectful of differing viewpoints
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards others

**Unacceptable behavior:**
- Trolling, insulting/derogatory comments, and personal attacks
- Public or private harassment
- Publishing others' private information
- Other conduct which could reasonably be considered inappropriate

### Enforcement

Instances of abusive, harassing, or otherwise unacceptable behavior may be reported by contacting the project maintainers. All complaints will be reviewed and investigated.

## 🎓 Learning Resources

New to Flutter? Check these out:

- [Flutter Documentation](https://docs.flutter.dev)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)

## 💬 Questions?

- **General questions**: Open a discussion on GitHub
- **Bug reports**: Create an issue
- **Security issues**: Email maintainers directly (see README)

## 🙏 Thank You!

Your contributions make this template better for everyone. We appreciate your time and effort!

---

**Happy Contributing! 🚀**
