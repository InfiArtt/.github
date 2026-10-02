# Contributing to InfiArtt projects

Thank you for helping! These guidelines apply to every InfiArtt repository that doesn't have its own `CONTRIBUTING.md`. If a project has one, follow that one instead.

## Reporting problems and ideas

- Use **New issue** in the project's repository and choose **Bug report** or **Feature request**. Each form has labelled fields, so it works well with a screen reader.
- Search the existing issues first, in case someone has already reported it.
- Security problems must not be reported in public issues. Follow our [security policy](SECURITY.md).

## Making a change

1. Create a branch from the latest `main`, with a short descriptive name such as `fix-volume-dialog`.
2. Make your change in small, focused commits with clear messages, for example `fix: start the volume dialog at the current volume`.
3. Run the project's tests, if it has any, and try the change yourself.
4. Open a pull request into `main` and fill in the checklist. A maintainer will review it.

Please don't push directly to `main`. In some projects, changes reaching `main` are released automatically.

## Accessibility comes first

InfiArtt is led by people with disabilities, and accessibility is part of what "done" means:

- Every control needs a label that a screen reader announces.
- Everything must be usable with the keyboard alone.
- Messages should say clearly what happened and what to do next.

## Secrets

Never commit passwords, API keys or tokens. Keep them in configuration files that git ignores, or in the repository's secrets for automation. If you commit one by accident, tell a maintainer straight away so it can be replaced; deleting the commit is not enough once it has been pushed.

## Code of conduct

Everyone taking part is expected to follow our [Code of Conduct](CODE_OF_CONDUCT.md).
