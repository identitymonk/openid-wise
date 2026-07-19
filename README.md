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

The rendered outputs are generated into the `build/` folder by `make`. HTML and
text are always produced. The Word (`.docx`) output is only generated when
[pandoc](https://pandoc.org/installing.html) is installed, so it is a local-only
convenience and is skipped in CI.

## Building the spec

Install dependencies:

```bash
gem install kramdown-rfc
pip install xml2rfc
# Optional, for the local Word (.docx) output only:
# install pandoc — see https://pandoc.org/installing.html
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

- Jeff Lombardo (Amazon Web Services) - jeff@authnopuz.xyz
- Dag Sneeggen (Signicat) - dag.sneeggen@signicat.com
- Sean O'Dell (CVS Health) - sean.odell@cvshealth.com
- Pieter Kasselman (Defakto Security) - pieter@defakto.security

## Contributing

Contributions are welcome. Please open an issue or submit a pull request.
