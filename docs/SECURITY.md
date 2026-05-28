# Security Policy

## Reporting a Vulnerability

Please do not create public issues for security vulnerabilities.

Instead, use one of the following private channels:

- **GitHub Security Advisory (preferred):** Open a private security advisory for this repository and include a clear description, impact, affected components, and steps to reproduce.
- **Organizational disclosure process:** If this repository is maintained within a VA/organizational context, follow the organization’s coordinated vulnerability disclosure process.

When reporting, please include:

- A clear description of the issue and why it is a security concern
- Steps to reproduce (minimal, sanitized)
- Expected vs actual behavior
- Any relevant logs or screenshots **without** secrets, credentials, or PII

## Best Practices

- Do not commit secrets, credentials, tokens, connection strings, or PII.
- Use environment variables and `config/local/` for local-only settings (and keep it out of Git).
- Keep export artifacts (e.g., Solution `.zip`, Canvas App `.msapp`) out of Git; attach to Releases if needed.
- Use sanitized sample data under `src/sharePoint/`.
- Review unpacked Power Platform artifacts for environment-specific IDs/URLs/emails before sharing broadly.
- When targeting GCC High, use the government endpoint for PAC authentication (e.g., `make.gov.powerapps.us`).
