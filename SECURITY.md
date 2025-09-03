# Security Policy

## Supported Versions

We actively support the following versions of the `lunchmoney` gem with security updates:

| Version | Supported          |
| ------- | ------------------ |
| 1.4.x   | :white_check_mark: |
| 1.3.x   | :white_check_mark: |
| < 1.3   | :x:                |

## Reporting a Vulnerability

We take the security of the `lunchmoney` gem seriously. If you discover a security vulnerability, please follow these steps:

### How to Report

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, please report security vulnerabilities by emailing us directly at:

- **Email**: [Create an email to the maintainer based on the GitHub profile]
- **Subject Line**: "[SECURITY] Vulnerability Report for lunchmoney gem"

### What to Include

Please include the following information in your report:

1. **Description**: A clear description of the vulnerability
2. **Impact**: The potential impact and severity of the vulnerability
3. **Reproduction Steps**: Step-by-step instructions to reproduce the issue
4. **Affected Versions**: Which versions of the gem are affected
5. **Suggested Fix**: If you have ideas for how to fix the issue (optional)
6. **Your Contact Information**: So we can follow up with questions if needed

### Response Timeline

We are committed to addressing security vulnerabilities promptly:

- **Acknowledgment**: We will acknowledge receipt of your vulnerability report within 48 hours
- **Initial Assessment**: We will provide an initial assessment within 5 business days
- **Status Updates**: We will provide regular updates on our progress
- **Resolution**: We aim to resolve critical vulnerabilities within 30 days

### Responsible Disclosure

We kindly ask that you:

- Give us reasonable time to investigate and fix the issue before public disclosure
- Avoid accessing, modifying, or deleting data that doesn't belong to you
- Don't perform actions that could harm the availability or integrity of our services
- Don't social engineer our team members or contractors

### Recognition

We appreciate the security research community's efforts to improve the security of our project. If you report a valid security vulnerability, we will:

- Acknowledge your contribution in our release notes (unless you prefer to remain anonymous)
- Work with you on the disclosure timeline
- Keep you informed throughout the remediation process

## Security Best Practices for Users

When using the `lunchmoney` gem in your applications:

### API Key Security

1. **Never commit API keys to version control**
   - Use environment variables (`LUNCHMONEY_TOKEN`)
   - Use secure credential management systems
   - Add API keys to your `.gitignore` file

2. **Rotate API keys regularly**
   - Generate new API keys periodically
   - Immediately revoke compromised keys

3. **Use least privilege access**
   - Only grant the minimum permissions necessary
   - Monitor API key usage for unusual activity

### Network Security

1. **Use HTTPS only**
   - The gem uses HTTPS by default for all API calls
   - Never disable SSL verification in production

2. **Network monitoring**
   - Monitor outbound API calls to LunchMoney
   - Set up alerts for unusual API usage patterns

### Dependency Security

1. **Keep dependencies updated**
   - Regularly update the `lunchmoney` gem
   - Monitor for security advisories affecting dependencies

2. **Audit your dependencies**

   ```bash
   # Install bundler-audit gem first
   gem install bundler-audit

   # Then audit your dependencies
   bundle audit
   ```

### Error Handling

1. **Don't log sensitive data**
   - API keys should never appear in logs
   - Be careful with error messages that might expose sensitive information

2. **Handle API errors gracefully**

   ```ruby
   api = LunchMoney::Api.new
   response = api.categories

   if response.is_a?(LunchMoney::Errors)
     # Handle error without exposing sensitive details
     logger.error "API call failed"
   end
   ```

## Security Features

This gem includes several security features:

- **HTTPS-only communication** with the LunchMoney API
- **Input validation** for API parameters
- **Error handling** that doesn't expose sensitive information
- **Dependency management** with regular updates

## Vulnerability History

We will maintain a record of resolved security vulnerabilities here:

- No security vulnerabilities have been reported to date

## Contact

For security-related questions or concerns, please contact:

- **Maintainer**: @mmenanno
- **Repository**: <https://github.com/mmenanno/lunchmoney>
- **Documentation**: <https://mmenanno.github.io/lunchmoney/>

---

Thank you for helping keep the `lunchmoney` gem and our community safe!
