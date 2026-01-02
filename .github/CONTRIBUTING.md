# Contributing

## Branches
- main — stable branch.
- Feature branches: feature/<short-description>.

## Commits
- Commit only unpacked source under src/, docs under docs/.
- Use clear, action-oriented commit messages.

# Contributing

Thank you for contributing to the EHRM Training & Booking App.

## Workflow Overview
- Use feature branches: `feature/<short-topic>` or `fix/<issue>`
- Keep changes small and focused; update tests/docs with code changes
- Open a Pull Request (PR) targeting `main`, with a clear summary and checklist

## Versioning & Changelog
- Follow Semantic Versioning (MAJOR.MINOR.PATCH)
- Maintain the root [CHANGELOG.md](../CHANGELOG.md) using "Keep a Changelog"
- Add entries under **[Unreleased]** during development; move to a new version section at release

## Commit Messages
- Prefer clear verbs and scope (optionally use Conventional Commits)
	- Examples: `feat(powerApps): add reservation validation`, `fix(flow): correct email subject`

## Power Platform ALM
- Canvas App: pack/unpack via VS Code tasks (PAC CLI)
	- Unpack: "Canvas: Unpack .msapp to src"
	- Pack: "Canvas: Pack src to .msapp"
- Solutions: export/unpack tasks are available for unmanaged workflows
- Review unpacked sources for environment-specific IDs/URLs/emails before public release

## Code Style
- See repository `.editorconfig` for standard formatting across languages
- Avoid unrelated formatting churn; keep diffs minimal

## PR Checklist
- [ ] Code compiles/tests pass (where applicable)
- [ ] Docs updated (README/CHANGELOG/user guides)
- [ ] Environment-specific values reviewed/sanitized
- [ ] Tasks/scripts updated if ALM steps changed

## Security & Privacy
- Do not commit secrets, credentials, or PII
- Use sanitized sample data in `src/sharePoint/lists`

## Questions
- Open a discussion or issue on GitHub.
