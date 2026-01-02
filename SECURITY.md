# Security Policy

## Reporting a Vulnerability

Please do not create public issues for security vulnerabilities. Instead:
- Provide a clear description of the vulnerability, impact, and steps to reproduce.
- Include any relevant logs or screenshots without sensitive information.

If this repository is maintained within an organizational context, follow the organization’s coordinated disclosure process.

## Best Practices
- Do not commit secrets, credentials, or PII.
- Use sanitized sample data under `src/sharePoint/lists`.
- Review unpacked artifacts (Power Apps/Flows) for environment-specific IDs/URLs/emails before public distribution.
