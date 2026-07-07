# WISE: Workload Identity Security Events

This repository contains the OpenID WISE (Workload Identity Security
Events) profile specification.

WISE defines Security Event Token (SET) event types for signaling
security-relevant state changes related to workload identities, building
on [RFC 8417](https://datatracker.ietf.org/doc/html/rfc8417) and the
[Shared Signals Framework](https://openid.net/specs/openid-sharedsignals-framework-1_0.html).

## Current Draft

| Specification | Source | Rendered |
|---------------|--------|----------|
| WISE Profile 1.0 | [openid-wise-profile-1_0.md](openid-wise-profile-1_0.md) | [HTML](build/openid-wise-profile-1_0.html) · [Word](build/openid-wise-profile-1_0.docx) |

The rendered HTML, text, and Word outputs are generated into the `build/` folder by `make`.

## Building the spec

Install dependencies:

```bash
gem install kramdown-rfc
pip install xml2rfc
# pandoc is required for the Word (.docx) output: https://pandoc.org/installing.html
```

Build all outputs (written to `build/`):

```bash
make
```

Or build individually:

```bash
mkdir -p build
kramdown-rfc2629 openid-wise-profile-1_0.md > build/openid-wise-profile-1_0.xml
xml2rfc build/openid-wise-profile-1_0.xml --html -o build/openid-wise-profile-1_0.html
xml2rfc build/openid-wise-profile-1_0.xml --text -o build/openid-wise-profile-1_0.txt
pandoc build/openid-wise-profile-1_0.html -f html -t docx -o build/openid-wise-profile-1_0.docx
```

## Related Specifications

- [WIMSE Architecture](https://www.ietf.org/archive/id/draft-ietf-wimse-arch-07.html)
- [WIMSE Workload Credentials](https://datatracker.ietf.org/doc/draft-ietf-wimse-workload-creds/)
- [WIMSE Workload Identifier](https://datatracker.ietf.org/doc/draft-ietf-wimse-identifier/)
- [AI Agent Authentication and Authorization](https://www.ietf.org/archive/id/draft-klrc-aiagent-auth-02.html)
- [OpenID RISC Profile](https://openid.net/specs/openid-risc-profile-specification-1_0.html)
- [OpenID CAEP Profile](https://openid.net/specs/openid-caep-specification-1_0.html)

## Authors

- Jeff Lombardo (Amazon Web Services) - jeff.lombardo@gmail.com
- Dag Sneeggen (Dendro) - dag@dendro.systems

## Contributing

Contributions are welcome. Please open an issue or submit a pull request.
