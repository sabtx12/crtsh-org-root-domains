# crtsh-org-root-domains

A simple **Bash script** to search **crt.sh** (Certificate Transparency logs) by Organization Name in SSL/TLS certificates, extract all associated domains, and derive the **root/apex domains**.

Ideal for **OSINT**, **reconnaissance**, **bug bounty**, **threat intelligence**, or mapping an organization's digital footprint using public certificate data.

## Features

- Queries the crt.sh JSON API using the `O=` parameter (Organization name).
- Extracts domains from both `common_name` and `name_value` (Subject Alternative Names).
- Removes wildcards (`*.`), strips `www.`, cleans whitespace.
- Filters for valid domain names.
- Extracts **root domains** (e.g., `example.com`, `example.co.uk`) using a heuristic for common public suffixes.
- Outputs:
  - `all_domains.txt` – All unique domains and subdomains found.
  - `root_domains.txt` – Deduplicated root/apex domains.
- Cleans up temporary files automatically.
- Clear English terminal output.

**Note**: Root domain extraction uses a simple heuristic that works well for common TLDs. For perfect accuracy across all public suffixes, consider integrating a Public Suffix List parser.

## Requirements

- `bash`
- `curl`
- `jq` (for JSON parsing)
- Standard Unix tools: `sed`, `grep`, `awk`, `sort`, `tr`

Install dependencies on Debian/Ubuntu:

```bash
sudo apt update && sudo apt install curl jq -y
```

## Usage
1 Save the script as crtsh-org-domains.sh
2 Make it executable:
```bash
chmod +x crtsh-org-domains.sh
```
3 Run:
```bash
./crtsh-org-domains.sh "Organization Name"
```
## Examples

```bash
./crtsh-org-domains.sh "Google LLC"
./crtsh-org-domains.sh "Microsoft Corporation"
```
## Sample Output (for "Example Co.")

```text
[*] Searching for Organization: Example Co.
[*] URL: https://crt.sh/?O=example%20Co.&output=json
[+] All domains extracted (all_domains.txt):
agm.example.co
mail.example.co
portal.example.co
tbplus.example.co
example.co
...

[+] Root domains extracted (root_domains.txt):
exam.co
example.net
example.org

[*] Done!
```
## Limitations
Organization name must closely match what's registered in certificates (crt.sh search is case-insensitive).
Large result sets may take time to process.
Heuristic root extraction may be inaccurate for uncommon or new TLDs.

## Future Improvements
Optional integration with Public Suffix List for perfect root domain extraction.
Support for outputting CSV/JSON.
Filtering by certificate validity dates.

## Credits
Powered by the free crt.sh service provided by Sectigo: https://crt.sh

## License
MIT License – Feel free to use, modify, and share!
