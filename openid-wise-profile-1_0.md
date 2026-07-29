---
stand_alone: true
ipr: none
cat: std # Check
submissiontype: IETF
wg: OpenID Shared Signals

docname: openid-wise-profile-1_0

title: "OpenID WISE Profile Specification 1.0 - draft 03"
abbrev: wiseset
lang: en
kw:
 - security events
 - workload identity
 - shared signals
 - SET

author:
- ins: J. Lombardo
  name: Jeff Lombardo
  org: Amazon Web Services
  email: jeff@authnopuz.xyz
- ins: D. Sneeggen
  name: Dag Sneeggen
  org: Signicat
  email: dag.sneeggen@signicat.com
- ins: S. O'Dell
  name: Sean O'Dell
  org: CVS Health
  email: sean.odell@cvshealth.com
- ins: P. Kasselman
  name: Pieter Kasselman
  org: Defakto Security
  email: pieter@defakto.security

normative:
  RFC5646:
  RFC7516:
  RFC7523:
  RFC8417:
  RFC8705:
  RFC9325:
  RFC9493:
  SSF:
    title: "OpenID Shared Signals Framework Specification 1.0"
    target: https://openid.net/specs/openid-sharedsignals-framework-1_0.html
    author:
      - ins: A. Tulshibagwale
        name: Atul Tulshibagwale
      - ins: T. Cappalli
        name: Tim Cappalli
      - ins: M. Scurtescu
        name: Marius Scurtescu
      - ins: A. Backman
        name: Annabelle Backman
      - ins: J. Bradley
        name: John Bradley
      - ins: S. Miel
        name: Shayne Miel
    date: 2025
  CAEP:
    title: "OpenID Continuous Access Evaluation Profile 1.0"
    target: https://openid.net/specs/openid-caep-1_0.html
    author:
      - ins: T. Cappalli
        name: Tim Cappalli
      - ins: A. Tulshibagwale
        name: Atul Tulshibagwale
    date: 2025
  RISC:
    title: "OpenID RISC Profile Specification 1.0"
    target: https://openid.net/specs/openid-risc-1_0-final.html
    author:
      - ins: M. Scurtescu
        name: Marius Scurtescu
      - ins: A. Backman
        name: Annabelle Backman
      - ins: P. Hunt
        name: Phil Hunt
      - ins: J. Bradley
        name: John Bradley
      - ins: S. Bounev
        name: Stan Bounev
      - ins: A. Tulshibagwale
        name: Atul Tulshibagwale
    date: 2025
  WIMSE-ARCH:
    title: "Workload Identity in a Multi System Environment (WIMSE) Architecture"
    target: https://www.ietf.org/archive/id/draft-ietf-wimse-arch-07.html
    author:
      - ins: J. Salowey
        name: Joe Salowey
      - ins: Y. Rosomakho
        name: Yaroslav Rosomakho
      - ins: H. Tschofenig
        name: Hannes Tschofenig
    date: 2026
  WIMSE-ID:
    title: "Workload Identifier"
    target: https://datatracker.ietf.org/doc/draft-ietf-wimse-identifier/
    author:
      - ins: Y. Rosomakho
        name: Yaroslav Rosomakho
      - ins: J. Salowey
        name: Joe Salowey
    date: 2026
  WIMSE-CRED:
    title: "WIMSE Workload Credentials"
    target: https://datatracker.ietf.org/doc/draft-ietf-wimse-workload-creds/
    author:
      - ins: B. Campbell
        name: Brian Campbell
      - ins: J. Salowey
        name: Joe Salowey
      - ins: A. Schwenkschuster
        name: Arndt Schwenkschuster
      - ins: Y. Sheffer
        name: Yaron Sheffer
      - ins: Y. Rosomakho
        name: Yaroslav Rosomakho
    date: 2026
  WPT:
    title: "WIMSE Workload Proof Token"
    target: https://datatracker.ietf.org/doc/draft-ietf-wimse-wpt/
    author:
      - ins: B. Campbell
        name: Brian Campbell
      - ins: A. Schwenkschuster
        name: Arndt Schwenkschuster
    date: 2026

informative:
  RFC7519:
  RFC7517:
  SPIFFE:
    title: "Secure Production Identity Framework for Everyone"
    target: https://spiffe.io/docs/latest/spiffe-specs/spiffe/
    date: 2024
  AGENT-AUTH:
    title: "AI Agent Authentication and Authorization"
    target: https://www.ietf.org/archive/id/draft-klrc-aiagent-auth-02.html
    author:
      - ins: P. Kasselman
        name: Pieter Kasselman
      - ins: D. Hardt
        name: Dick Hardt
      - ins: A. Schwenkschuster
        name: Arndt Schwenkschuster
    date: 2026
  CIMD:
    title: "Client ID Metadata Document"
    target: https://www.ietf.org/archive/id/draft-parecki-oauth-client-id-metadata-document-07.html
    author:
      - ins: A. Parecki
        name: Aaron Parecki
    date: 2025
  VEX:
    title: "Minimum Requirements for Vulnerability Exploitability eXchange (VEX)"
    target: https://www.cisa.gov/resources-tools/resources/minimum-requirements-vulnerability-exploitability-exchange-vex
    date: 2023
  WIMSE-CBC:
    title: "Condition-Bounded Credentials for Workload and Agent Identity: Non-Exfiltratable Keys and Validity by Presence"
    target: https://datatracker.ietf.org/doc/draft-winmagic-wimse-condition-bounded-credentials/
    author:
      - ins: T. Nguyen-Huu
        name: Thi Nguyen-Huu
      - ins: S. Nikitin
        name: Sergei Nikitin
      - ins: J. O'Leary
        name: John O'Leary
    date: 2026
  IANA.JOSE:
    title: "JSON Object Signing and Encryption (JOSE)"
    target: https://www.iana.org/assignments/jose
    author:
      - org: IANA
    date: false

--- abstract

This document defines the Workload Identity Security Events (WISE) profile, a set of Security Event Token (SET) event types for signaling security-relevant state changes related to workload identities. WISE builds on the SET framework defined in {{RFC8417}} and the Shared Signals Framework {{SSF}} to enable trust domains and identity infrastructure components to communicate workload identity lifecycle events, credential and key management events, trust material changes, and posture evaluation events.

WISE complements the existing RISC and CAEP profiles by addressing the non-human identity domain, specifically workload-to-workload authentication and the workload identity lifecycle as described in the WIMSE architecture {{WIMSE-ARCH}}.

--- middle

# Introduction

Modern distributed systems rely on workloads, software entities executing for a specific purpose, to deliver services. These workloads include microservices, containers, virtual machines, serverless functions, and increasingly, AI agents operating autonomously or on behalf of users.

The WIMSE architecture {{WIMSE-ARCH}} establishes the foundational model for workload identity: a trust domain, typically governed by a single authority, provisions cryptographic credentials to workloads that allow them to authenticate to one another. The credentials are short-lived by design, binding a workload identifier to key material through either Workload Identity Tokens (WIT) at the application layer or Workload Identity Certificates (WIC) at the transport layer, as defined in {{WIMSE-CRED}}.

The emergence of AI agents as a new category of workload, as described in {{AGENT-AUTH}}, introduces additional security coordination requirements. AI agents interact with tools, services, and other agents across trust domain boundaries, often autonomously. Like any workload, they require identifiers, credentials, and posture evaluation before credentials are issued. The security events defined in this specification apply equally to traditional service workloads and to AI agent workloads.

While the RISC {{RISC}} profile addresses risk signals for user accounts and the CAEP {{CAEP}} profile addresses continuous access evaluation for user sessions, no standardized event profile exists for communicating security-relevant state changes about workload identities. This specification fills that gap.

## Scope

WISE defines event types that enable:

- Trust domain authorities to signal credential and key lifecycle changes to federated peers and relying parties.
- Identity infrastructure components to communicate posture evaluation and policy changes that affect workload trust.
- Cross-domain signaling of trust material updates that require immediate action by relying parties.
- Runtime posture change notifications that may affect the trust evaluation of a workload.
- Supply-chain changes including updated or revoked provenance, and changes to the vulnerability status of a workload's components that require relying parties to re-evaluate trust.

## Alignment with WIMSE Architecture

This specification aligns with the WIMSE architecture {{WIMSE-ARCH}}, which defines a model where:

- A trust domain is a logical grouping of systems that share a common set of security controls and policies, identified by a fully qualified domain name.
- Workload identity credentials are issued under the authority of a trust domain, which maps to one or more trust anchors used to validate them.
- Workload identifiers are URIs that uniquely name a workload within a trust domain, as defined in {{WIMSE-ID}}.

Because a trust domain acts as the issuing authority for the workloads within it, WISE events are designed to signal state changes:

1. From a trust domain authority to federated peers, when changes affect the ability of external parties to validate or trust workloads from that domain.
2. From a trust domain authority to relying parties within the same domain, for credential and key lifecycle or posture changes that require action.

## Notational Conventions

{::boilerplate bcp14}

# Event Types

The base URI for WISE event types is:

~~~
https://schemas.openid.net/secevent/wise/event-type/
~~~

## Correlating Related Events {#correlating-related-events}

A single underlying occurrence may cause a Transmitter to emit more than one SET — for example, a lifecycle change and its companion credential event, a runtime compromise and a resulting credential revocation, a posture failure and a resulting renewal failure, or a new federation and the trust anchors that accompany it. When a Transmitter emits multiple SETs that describe the same underlying occurrence, it SHOULD set the same value in the OPTIONAL `txn` (transaction identifier) claim {{RFC8417}} on each of them, so that a Receiver can recognise that the events share a cause. This applies regardless of event type.

## Common Optional Claims {#common-optional-claims}

Unless stated otherwise, any WISE event MAY include the common optional claims defined in Section 2 of {{CAEP}}. In particular:

- **reason_admin** - OPTIONAL. A localizable administrative message intended for logging and auditing, as defined in {{CAEP}}. Its value is a JSON object containing one or more key/value pairs, where each key is a BCP 47 {{RFC5646}} language tag and each value is the locale-specific message.
- **reason_user** - OPTIONAL. A localizable, user-facing message, as defined in {{CAEP}}. Its value follows the same JSON object structure as `reason_admin`.
- **initiating_entity** - OPTIONAL. A JSON string describing what triggered the event, as defined in {{CAEP}}: one of `admin`, `user`, `policy`, or `system`.

To avoid repetition, these common claims are not listed in the per-event attribute definitions in the following sections; any event MAY carry them, and some examples include them for illustration.

When a WISE event includes `reason_admin` or `reason_user`, the claim MUST use the localizable JSON object structure defined above rather than a plain string. The following is a non-normative example:

~~~ json
"reason_admin": {
  "en": "Private key material detected in public repository",
  "de": "Privates Schluesselmaterial in oeffentlichem Repository entdeckt"
}
~~~

## Workload Credential Lifecycle Events

These events signal changes to the credentials issued to workloads by
the trust domain authority.

This specification defines event types that apply to workload
credentials regardless of their security properties. Inclusion of a
credential type in this specification does not constitute a
recommendation for its use. Deployments SHOULD prefer credentials with
proof-of-possession semantics as defined in {{WIMSE-CRED}}. Legacy
credential types are included to enable security event signaling for
environments operating heterogeneous credential ecosystems or
transitioning toward WIMSE-compliant infrastructure.

Proof-of-possession credentials bind a key to the workload identity: a WIT carries the public key in its `cnf` claim, and the corresponding private key is used to produce Workload Proof Tokens (WPT) {{WPT}}. WISE does not define separate events for the lifecycle of such keys. Because a bound key has no value once its credential is revoked, a compromised or rotated key is signalled through the credential events in this section: revoke the affected credential (with `reason` set to `key_compromise` where applicable) and, where a replacement is issued, emit `credential-rotated` or `credential-issued`.

### credential-issued

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/credential-issued`

The `credential-issued` event signals that a new credential was issued to a workload by the trust domain authority.

Attributes:

- **credential_type** - REQUIRED. The type of credential issued. Possible values:
    - `wit` - Workload Identity Token as defined in {{WIMSE-CRED}}
    - `wic` - Workload Identity Certificate as defined in {{WIMSE-CRED}}
    - `x509_svid` - X.509-SVID as defined in {{SPIFFE}}
    - `x509_generic` - Generic X.509 certificate not conforming to WIC or SVID profiles
    - `oauth_private_key_jwt` - OAuth 2.0 client authentication using private_key_jwt {{RFC7523}}
    - `oauth_mtls` - OAuth 2.0 mutual TLS client authentication {{RFC8705}}
    - `oauth_client_secret` - OAuth 2.0 client_id and client_secret credential pair
    - `api_key` - Static API key or long-lived bearer token
- Additional values MAY be defined by profiling specifications or private agreement between Transmitter and Receiver.
- **credential_id** - OPTIONAL. An identifier for the credential (e.g., certificate serial number, `jti` claim value).
- **expiry** - OPTIONAL. The expiration time of the credential as a JSON number (NumericDate per {{RFC7519}}).
- **key_storage** - OPTIONAL. Where the private key bound to the credential is stored. Possible values:
    - `hardware` - Key is stored in a hardware security module, TPM, secure enclave, or equivalent tamper-resistant storage.
    - `software` - Key is stored in software (filesystem, memory, or application-managed keystore).
- **key_storage_ecosystem** - OPTIONAL. Free-text description of the hardware or software environment protecting the key. Examples: "iPhone 17s, iOS 23 patch 6", "AWS Nitro Enclave", "Azure Confidential VM, AMD SEV-SNP", "FIPS 140-3 Level 3 HSM".
- **event_timestamp** - OPTIONAL. The time at which the credential was issued. JSON number representing seconds since Unix epoch.

The following example is non-normative.

~~~ json
{
  "iss": "https://authority.example.com/",
  "jti": "wise-evt-001",
  "iat": 1700000000,
  "aud": "https://rp.partner.example.net/wise",
  "sub_id": {
    "format": "uri",
    "uri": "wimse://trust.example.com/workload/payment-service"
  },
  "events": {
    "https://schemas.openid.net/secevent/wise/event-type/credential-issued": {
      "credential_type": "wic",
      "credential_id": "serial:ABC123DEF456",
      "expiry": 1700086400
    }
  }
}
~~~
{: #fig-credential-issued title="Example: Credential Issued"}

### credential-rotated

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/credential-rotated`

The `credential-rotated` event signals that a workload's credential was rotated. A new credential replaces the previous one.

Attributes:

- **credential_type** - REQUIRED. The type of credential rotated. Same values as in {{credential-issued}}.
- **previous_credential_id** - OPTIONAL. Identifier of the credential being replaced.
- **new_credential_id** - OPTIONAL. Identifier of the newly issued credential.
- **grace_period_end** - OPTIONAL. The time until which the previous credential remains valid. JSON number (NumericDate).
- **event_timestamp** - OPTIONAL. The time at which the rotation occurred.

The following example is non-normative.

~~~ json
{
  "iss": "https://authority.example.com/",
  "jti": "wise-evt-002",
  "iat": 1700000000,
  "aud": "https://rp.partner.example.net/wise",
  "sub_id": {
    "format": "uri",
    "uri": "wimse://trust.example.com/workload/payment-service"
  },
  "events": {
    "https://schemas.openid.net/secevent/wise/event-type/credential-rotated": {
      "credential_type": "wit",
      "previous_credential_id": "jti:wit-2024-q4-001",
      "new_credential_id": "jti:wit-2024-q4-002",
      "grace_period_end": 1700003600
    }
  }
}
~~~
{: #fig-credential-rotated title="Example: Credential Rotated"}

### credential-revoked

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/credential-revoked`

The `credential-revoked` event signals that a workload's credential was explicitly revoked before its natural expiry.

Attributes:

- **credential_type** - REQUIRED. The type of credential revoked.
- **credential_id** - OPTIONAL. Identifier of the revoked credential.
- **reason** - OPTIONAL. Why the credential was revoked. Possible values:
    - `compromise` - The credential is believed compromised.
    - `key_compromise` - The private key bound to the credential is believed compromised.
    - `superseded` - Replaced by a new credential.
    - `cessation` - The workload no longer operates.
    - `policy_violation` - Revoked due to a policy violation.
- **event_timestamp** - OPTIONAL. The time at which revocation occurred.

The following example is non-normative.

~~~ json
{
  "iss": "https://authority.example.com/",
  "jti": "wise-evt-003",
  "iat": 1700000000,
  "aud": "https://rp.partner.example.net/wise",
  "sub_id": {
    "format": "uri",
    "uri": "wimse://trust.example.com/workload/payment-service"
  },
  "events": {
    "https://schemas.openid.net/secevent/wise/event-type/credential-revoked": {
      "credential_type": "wic",
      "credential_id": "serial:ABC123DEF456",
      "reason": "compromise"
    }
  }
}
~~~
{: #fig-credential-revoked title="Example: Credential Revoked"}

### credential-compromise

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/credential-compromise`

The `credential-compromise` event signals that a workload credential is believed to have been compromised. This is an advisory signal that may precede or accompany a `credential-revoked` event.

Attributes:

- **credential_type** - REQUIRED. The type of credential compromised.
- **credential_id** - OPTIONAL. Identifier of the compromised credential.
- **event_timestamp** - OPTIONAL. The time at which the compromise was detected.

The following example is non-normative.

~~~ json
{
  "iss": "https://authority.example.com/",
  "jti": "wise-evt-004",
  "iat": 1700000000,
  "aud": "https://rp.partner.example.net/wise",
  "sub_id": {
    "format": "uri",
    "uri": "wimse://trust.example.com/workload/payment-service"
  },
  "events": {
    "https://schemas.openid.net/secevent/wise/event-type/credential-compromise": {
      "credential_type": "wit",
      "credential_id": "jti:wit-signing-key-2024-q4",
      "reason_admin": {
        "en": "Private key material detected in public repository"
      }
    }
  }
}
~~~
{: #fig-credential-compromise title="Example: Credential Compromise"}

### credential-renewal-failure

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/credential-renewal-failure`

The `credential-renewal-failure` event signals that the credential provisioning pipeline failed to renew a workload's credential. In the WIMSE model, credentials are intentionally short-lived to force regular posture evaluation before re-issuance. Under normal operation, renewal happens automatically. This event indicates that the renewal process has failed, and the workload may lose its ability to authenticate once the current credential expires.

This event reports the operational outcome of a failed renewal, which can have several causes (see `failure_reason` below) — the Credential Service being unreachable, a policy denial, an internal error, or a failed posture evaluation. It is distinct from `posture-evaluation-failed`, which reports a posture failure as a security signal in its own right. Failed posture evaluation is only one possible cause of a renewal failure, and a renewal failure is only one possible consequence of a posture failure. When a renewal fails specifically because of posture evaluation, a Transmitter emits `credential-renewal-failure` with `failure_reason` `posture_evaluation_failed` and MAY also emit `posture-evaluation-failed`, correlated using the `txn` claim (see {{correlating-related-events}}).

Attributes:

- **credential_type** - REQUIRED. The type of credential that failed to renew.
- **credential_id** - OPTIONAL. Identifier of the credential that was not renewed.
- **current_expiry** - OPTIONAL. Expiration of the current (last valid) credential. JSON number (NumericDate).
- **failure_reason** - OPTIONAL. Why renewal failed. Possible values:
    - `credential_service_unreachable` - Cannot reach the Credential Service (Section 3.2.1 of {{WIMSE-ARCH}}).
    - `posture_evaluation_failed` - The workload did not pass posture evaluation.
    - `policy_denied` - Issuance policy denied renewal.
    - `internal_error` - Internal error in the provisioning pipeline.
- **event_timestamp** - OPTIONAL. Time the failure was detected.

The following example is non-normative.

~~~ json
{
  "iss": "https://authority.example.com/",
  "jti": "wise-evt-005",
  "iat": 1700000000,
  "aud": "https://rp.partner.example.net/wise",
  "sub_id": {
    "format": "uri",
    "uri": "wimse://trust.example.com/workload/payment-service"
  },
  "events": {
    "https://schemas.openid.net/secevent/wise/event-type/credential-renewal-failure": {
      "credential_type": "wit",
      "current_expiry": 1700003600,
      "failure_reason": "posture_evaluation_failed"
    }
  }
}
~~~
{: #fig-credential-renewal-failure title="Example: Credential Renewal Failure"}

## Workload Lifecycle Events

These events signal changes to the lifecycle state of a workload as managed by the trust domain authority.

Each of these events conveys only the lifecycle state change; the corresponding credential effect is carried by a separate companion event (`credential-revoked` or `credential-issued`), correlated using the `txn` claim as described in {{correlating-related-events}}.

### workload-disabled

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/workload-disabled`

The `workload-disabled` event signals that the trust domain authority has suspended a workload. The authority will no longer issue credentials for this workload, and it cancels the workload's currently valid credentials. This event conveys only the lifecycle state change; the resulting credential cancellation is signalled separately through accompanying `credential-revoked` events. A Transmitter SHOULD emit those credential events together with this event.

Attributes:

- **reason** - OPTIONAL. Why the workload was disabled. Possible values:
    - `compromise` - The workload is believed compromised.
    - `policy_violation` - Suspended due to a policy violation.
    - `administrative` - Disabled by an administrator.
    - `maintenance` - Temporarily disabled for maintenance.
- **event_timestamp** - OPTIONAL. Time of disablement.

### workload-enabled

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/workload-enabled`

The `workload-enabled` event signals that a previously disabled workload is active again. The trust domain authority will resume issuing credentials for this workload. As with disablement, this event conveys only the lifecycle state change; any credential provisioned as a result is signalled separately through an accompanying `credential-issued` event.

Attributes:

- **event_timestamp** - OPTIONAL. Time of re-enablement.

### workload-purged

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/workload-purged`

The `workload-purged` event signals that a workload has been permanently removed from the trust domain. This is irreversible. The workload will not be re-provisioned. All credentials previously issued for this workload MUST be considered invalid. As with `workload-disabled`, this event conveys only the lifecycle state change; the resulting credential cancellation is signalled separately through accompanying `credential-revoked` events.

Attributes:

- **event_timestamp** - OPTIONAL. Time of removal.

## Trust and Federation Events

These events signal changes to the trust material and federation relationships that federated peers and relying parties use to validate workload identity credentials from a trust domain.

Two related lifecycles are covered, each modelled with explicit create, update, and delete events. The trust anchors (keys and CAs) that validate a trust domain's credentials are managed through `trust-anchor-added`, `trust-anchor-rotated`, and `trust-anchor-revoked`. The federation relationship between trust domains, which determines whether one domain accepts credentials issued by another, is managed through `trust-domain-federation-established`, `trust-domain-federation-updated`, and `trust-domain-federation-revoked`. Replacing an entire trust bundle in a single operation is conveyed as the corresponding set of `trust-anchor-added` and `trust-anchor-revoked` events.

### trust-anchor-added

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/trust-anchor-added`

The `trust-anchor-added` event signals that a new trust anchor was added for a trust domain, alongside any existing anchors. Examples include pre-staging a new signing key ahead of a rotation, or bringing online a new data center, region, or cloud provider that operates under the same trust domain. Relying parties and federated peers MUST add the new material to the set they accept for the domain.

Attributes:

- **anchor_type** - REQUIRED. The type of trust material. Possible values:
    - `x509_ca` - X.509 CA certificate(s) used to validate Workload Identity Certificates (WIC) or X.509-SVIDs.
    - `jwks` - JSON Web Key Set {{RFC7517}} used to validate Workload Identity Tokens (WIT).
- **trust_domain** - REQUIRED. The FQDN of the trust domain the anchor belongs to.
- **key_id** - OPTIONAL. Identifier of the added anchor. For JWKS, the `kid` value. For X.509, the certificate serial number or Subject Key Identifier.
- **key_details** - OPTIONAL. A JSON object describing the added key, so a receiver can act (for example, recognise support for a new signature algorithm such as ECDSA alongside RSA) without fetching and diffing the bundle. When present, its members SHOULD use values from the JSON Object Signing and Encryption (JOSE) registries {{IANA.JOSE}}:
    - `type` - The key type, using a value from the "JSON Web Key Types" registry (e.g., `EC`, `RSA`, `OKP`, `oct`).
    - `name` - The algorithm, using an "Algorithm Name" from the "JSON Web Signature and Encryption Algorithms" registry (e.g., `RS256`, `ES256`, `EdDSA`).
    - `use` - The public key use, using a value from the "JSON Web Key Use" registry (e.g., `sig`, `enc`).
- **jwks_uri** - OPTIONAL. When `anchor_type` is `jwks`, the URI to fetch the updated JWK Set.
- **x509_bundle_uri** - OPTIONAL. When `anchor_type` is `x509_ca`, the URI to fetch the updated CA bundle.
- **effective_at** - OPTIONAL. When the new anchor becomes active. JSON number (NumericDate).
- **reason** - OPTIONAL. Why the anchor was added. Possible values:
    - `new_environment` - A new environment (data center, region, or cloud provider) under the same trust domain was brought online.
    - `additional_key` - An additional concurrent anchor was introduced (for example, to support a new signature algorithm alongside an existing one).
    - `scheduled_rotation` - A new key was pre-staged ahead of a scheduled rotation.
- **event_timestamp** - OPTIONAL. Time the anchor was added.

The following example is non-normative.

~~~ json
{
  "iss": "https://authority.example.com/",
  "jti": "wise-evt-020",
  "iat": 1700000000,
  "aud": "https://federation-peer.example.net/wise",
  "sub_id": {
    "format": "uri",
    "uri": "wimse://trust.example.com"
  },
  "events": {
    "https://schemas.openid.net/secevent/wise/event-type/trust-anchor-added": {
      "anchor_type": "jwks",
      "trust_domain": "trust.example.com",
      "jwks_uri": "https://authority.example.com/.well-known/jwks.json",
      "key_id": "kid:ecdsa-2026",
      "key_details": {
        "type": "EC",
        "name": "ES256",
        "use": "sig"
      },
      "effective_at": 1700000000,
      "reason": "additional_key"
    }
  }
}
~~~
{: #fig-trust-anchor-added title="Example: Trust Anchor Added"}

### trust-anchor-rotated

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/trust-anchor-rotated`

The `trust-anchor-rotated` event signals that an existing trust anchor for a trust domain was replaced by new material. Relying parties and federated peers MUST begin accepting the new anchor and SHOULD stop accepting the previous one once any grace period ends.

Attributes:

- **anchor_type** - REQUIRED. The type of trust material. Same values as in {{trust-anchor-added}}.
- **trust_domain** - REQUIRED. The FQDN of the trust domain whose anchor was rotated.
- **previous_key_id** - OPTIONAL. Identifier of the anchor being replaced.
- **new_key_id** - OPTIONAL. Identifier of the replacement anchor.
- **jwks_uri** - OPTIONAL. When `anchor_type` is `jwks`, the URI to fetch the updated JWK Set.
- **x509_bundle_uri** - OPTIONAL. When `anchor_type` is `x509_ca`, the URI to fetch the updated CA bundle.
- **effective_at** - OPTIONAL. When the new material becomes active. JSON number (NumericDate).
- **old_material_expiry** - OPTIONAL. When the previous material ceases to be valid (grace period end). JSON number (NumericDate).
- **reason** - OPTIONAL. Why the rotation occurred. Possible values:
    - `scheduled_rotation` - Routine key rotation.
    - `compromise` - The previous anchor is believed compromised.
    - `policy_change` - Rotated due to updated security policy.
    - `expiry` - Proactive rotation before scheduled expiry.
- **event_timestamp** - OPTIONAL. Time of rotation.

The following example is non-normative.

~~~ json
{
  "iss": "https://authority.example.com/",
  "jti": "wise-evt-021",
  "iat": 1700000000,
  "aud": "https://federation-peer.example.net/wise",
  "sub_id": {
    "format": "uri",
    "uri": "wimse://trust.example.com"
  },
  "events": {
    "https://schemas.openid.net/secevent/wise/event-type/trust-anchor-rotated": {
      "anchor_type": "jwks",
      "trust_domain": "trust.example.com",
      "previous_key_id": "kid:signing-2024-q4",
      "new_key_id": "kid:signing-2025-q1",
      "jwks_uri": "https://authority.example.com/.well-known/jwks.json",
      "effective_at": 1700000000,
      "old_material_expiry": 1700604800,
      "reason": "scheduled_rotation"
    }
  }
}
~~~
{: #fig-trust-anchor-rotated title="Example: Trust Anchor Rotated (JWKS Rotation)"}

### trust-anchor-revoked

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/trust-anchor-revoked`

The `trust-anchor-revoked` event signals that a trust anchor for a trust domain was withdrawn and MUST no longer be used to validate credentials. This covers both explicit revocation (for example, a compromised CA) and removal of an anchor that has reached end of life.

Attributes:

- **anchor_type** - REQUIRED. The type of trust material. Same values as in {{trust-anchor-added}}.
- **trust_domain** - REQUIRED. The FQDN of the trust domain whose anchor was revoked.
- **key_id** - OPTIONAL. Identifier of the revoked anchor. For JWKS, the `kid` value. For X.509, the certificate serial number or Subject Key Identifier.
- **jwks_uri** - OPTIONAL. When `anchor_type` is `jwks`, the URI to fetch the JWK Set reflecting the removal.
- **x509_bundle_uri** - OPTIONAL. When `anchor_type` is `x509_ca`, the URI to fetch the CA bundle reflecting the removal.
- **effective_at** - OPTIONAL. When the revocation takes effect. JSON number (NumericDate).
- **reason** - OPTIONAL. Why the anchor was revoked. Possible values:
    - `compromise` - The anchor is believed compromised.
    - `policy_change` - Revoked due to updated security policy.
    - `superseded` - Replaced by other material and no longer needed.
    - `expiry` - The anchor reached end of life.
- **event_timestamp** - OPTIONAL. Time of revocation.

The following example is non-normative.

~~~ json
{
  "iss": "https://authority.example.com/",
  "jti": "wise-evt-022",
  "iat": 1700000000,
  "aud": "https://federation-peer.example.net/wise",
  "sub_id": {
    "format": "uri",
    "uri": "wimse://trust.example.com"
  },
  "events": {
    "https://schemas.openid.net/secevent/wise/event-type/trust-anchor-revoked": {
      "anchor_type": "x509_ca",
      "trust_domain": "trust.example.com",
      "key_id": "serial:CA-ROOT-2023-001",
      "reason": "compromise"
    }
  }
}
~~~
{: #fig-trust-anchor-revoked title="Example: Trust Anchor Revoked (CA Compromise)"}

### trust-domain-federation-established

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/trust-domain-federation-established`

The `trust-domain-federation-established` event signals that a new trust domain has been federated. Relying parties and federated peers MAY begin accepting workload credentials originating from the specified trust domain, validated against the associated trust anchors. This is the counterpart to `trust-domain-federation-revoked`, and typically accompanies the trust material for the new domain (either inline via `jwks_uri` / `x509_bundle_uri` or through subsequent `trust-anchor-added` events).

Attributes:

- **trust_domain** - REQUIRED. The FQDN of the newly federated trust domain.
- **anchor_type** - OPTIONAL. The type of trust material used to validate credentials from the new domain. Same values as in {{trust-anchor-added}}: `x509_ca` or `jwks`.
- **jwks_uri** - OPTIONAL. When `anchor_type` is `jwks`, the URI to fetch the JWK Set {{RFC7517}} for the federated domain.
- **x509_bundle_uri** - OPTIONAL. When `anchor_type` is `x509_ca`, the URI to fetch the CA bundle for the federated domain.
- **effective_at** - OPTIONAL. When the federation becomes active. JSON number (NumericDate).
- **reason** - OPTIONAL. Why federation was established. Possible values:
    - `onboarding` - A new organization joined the federation.
    - `expansion` - A new data center, region, or cloud provider was added to the enterprise.
    - `administrative` - Administrative decision to establish federation.
    - `contractual` - A new business relationship was established.
- **event_timestamp** - OPTIONAL. Time the decision was made.

The following example is non-normative.

~~~ json
{
  "iss": "https://authority.example.com/",
  "jti": "wise-evt-023",
  "iat": 1700000000,
  "aud": "https://federation-peer.example.net/wise",
  "sub_id": {
    "format": "uri",
    "uri": "wimse://newpartner.example.org"
  },
  "events": {
    "https://schemas.openid.net/secevent/wise/event-type/trust-domain-federation-established": {
      "trust_domain": "newpartner.example.org",
      "anchor_type": "jwks",
      "jwks_uri": "https://authority.newpartner.example.org/.well-known/jwks.json",
      "effective_at": 1700000000,
      "reason": "onboarding"
    }
  }
}
~~~
{: #fig-federation-established title="Example: Trust Domain Federation Established"}

### trust-domain-federation-updated

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/trust-domain-federation-updated`

The `trust-domain-federation-updated` event signals that the terms of an existing federation with a trust domain changed without revoking it. Examples include a change to the set of workloads or name constraints that are trusted, or a change to which trust anchors validate the federated domain. Relying parties MUST update their federation configuration accordingly while continuing to trust the domain.

Attributes:

- **trust_domain** - REQUIRED. The FQDN of the federated trust domain whose federation terms changed.
- **effective_at** - OPTIONAL. When the updated terms take effect. JSON number (NumericDate).
- **reason** - OPTIONAL. Why the federation was updated. Possible values:
    - `policy_change` - Updated due to a change in federation policy.
    - `anchor_update` - The trust anchors used to validate the federated domain changed.
    - `administrative` - Administrative decision.
    - `contractual` - Business relationship terms changed.
- **event_timestamp** - OPTIONAL. Time the decision was made.

### trust-domain-federation-revoked

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/trust-domain-federation-revoked`

The `trust-domain-federation-revoked` event signals that a previously federated trust domain is no longer trusted. All workload credentials originating from the specified trust domain MUST be rejected.

Attributes:

- **trust_domain** - REQUIRED. The FQDN of the trust domain that is no longer trusted.
- **reason** - OPTIONAL. Why federation was revoked. Possible values:
    - `compromise` - The federated domain is believed compromised.
    - `policy_violation` - Federation revoked due to policy.
    - `administrative` - Administrative decision to end federation.
    - `contractual` - Business relationship ended.
- **effective_at** - OPTIONAL. When the revocation takes effect. JSON number (NumericDate).
- **event_timestamp** - OPTIONAL. Time the decision was made.

## Policy and Posture Evaluation Events

These events signal changes to the policies governing workload identity issuance, posture evaluation, and credential validation within or across trust domains.

In the WIMSE model, posture evaluation is the process by which the Credential Service assesses a workload's runtime environment, software integrity, and deployment context before issuing or renewing credentials. This replaces the traditional notion of static attestation with a continuous evaluation model.

### issuance-policy-changed

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/issuance-policy-changed`

The `issuance-policy-changed` event signals that the policy governing credential issuance for workloads has changed. This may affect which workloads are eligible for credentials, what credential types are issued, lifetime constraints, or required posture evidence.

Attributes:

- **policy_id** - OPTIONAL. Identifier of the policy that changed.
- **effective_at** - OPTIONAL. When the new policy takes effect.
- **event_timestamp** - OPTIONAL. Time the change was made.

### posture-evaluation-policy-changed

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/posture-evaluation-policy-changed`

The `posture-evaluation-policy-changed` event signals that the posture evaluation policy has changed. This may affect which evidence is required from workloads, what evaluation criteria apply, or what deployment context signals are considered during credential issuance and renewal.

Attributes:

- **policy_id** - OPTIONAL. Identifier of the policy that changed.
- **effective_at** - OPTIONAL. When the new policy takes effect.
- **event_timestamp** - OPTIONAL. Time the change was made.

### validation-policy-changed

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/validation-policy-changed`

The `validation-policy-changed` event signals that the policy used to validate workload identity credentials at relying parties has changed. This includes changes to trust anchor validation rules, claim validation requirements, audience restrictions, or acceptable credential types.

Attributes:

- **policy_id** - OPTIONAL. Identifier of the policy that changed.
- **effective_at** - OPTIONAL. When the new policy takes effect.
- **event_timestamp** - OPTIONAL. Time the change was made.

### posture-evaluation-failed

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/posture-evaluation-failed`

The `posture-evaluation-failed` event signals that a workload did not pass posture evaluation. The Credential Service determined that the workload's runtime environment, software integrity, or deployment context did not meet the requirements for credential issuance.

Posture evaluation is a security-critical checkpoint, so its failure warrants a dedicated event rather than being buried inside another outcome. It may occur at initial issuance, at renewal, or during continuous re-evaluation, and this event reports the posture failure itself independently of any particular credential operation. A posture failure does not necessarily cause a `credential-renewal-failure` (for example, it may occur outside a renewal), and a `credential-renewal-failure` may occur for reasons unrelated to posture. When a renewal fails because of posture evaluation, the two events are emitted together and correlated using the `txn` claim (see {{correlating-related-events}}).

Attributes:

- **evaluation_type** - OPTIONAL. The scope of evaluation that failed. Possible values:
    - `platform` - Platform-level evaluation (e.g., node integrity, TEE verification).
    - `workload` - Workload-level evaluation (e.g., binary identity, image hash).
    - `runtime` - Runtime environment evaluation (e.g., configuration compliance, network posture).
- **reason** - OPTIONAL. Why the evaluation failed.
- **event_timestamp** - OPTIONAL. Time of the failure.

### posture-evaluation-succeeded

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/posture-evaluation-succeeded`

The `posture-evaluation-succeeded` event signals that a workload successfully passed posture evaluation. This event is produced as part of the regular credential provisioning process. It confirms that the workload met the Credential Service's requirements and that a credential was or will be issued.

This event does not imply that a prior failure occurred. It is generated each time posture evaluation completes successfully, providing an audit trail and enabling downstream systems to track the health of the provisioning pipeline.

Attributes:

- **evaluation_type** - OPTIONAL. The scope of evaluation that succeeded.
- **event_timestamp** - OPTIONAL. Time of successful evaluation.

## Runtime Posture Events

### workload-baseline-changed

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/workload-baseline-changed`

The `workload-baseline-changed` event signals that a workload's runtime environment, deployment context, or metadata has changed. This may trigger re-evaluation of trust by relying parties or require the workload to undergo posture evaluation before new credentials are issued.

Attributes:

- **reason** - OPTIONAL. Why the baseline changed. Possible values:
    - `migration` - Workload moved to a different node, region, or zone.
    - `scaling` - New instances added or removed.
    - `redeployment` - Workload was redeployed (same identity, new instance).
    - `image_update` - Runtime image or binary was updated.
    - `config_change` - Configuration affecting identity posture changed.
    - `node_reassignment` - Underlying compute node changed.
- **previous_context** - OPTIONAL. A JSON object describing the prior runtime environment. See the guidance below on the interoperable key set and on limiting sensitive detail.
- **current_context** - OPTIONAL. A JSON object describing the new runtime environment, using the same keys as `previous_context` so the two can be compared.
- **posture_evaluation_status** - OPTIONAL. Whether posture re-evaluation has occurred. Possible values:
    - `succeeded` - Re-evaluation completed successfully.
    - `pending` - Re-evaluation has not yet occurred.
    - `failed` - Re-evaluation was attempted and failed.
- **event_timestamp** - OPTIONAL. Time of the change.

For interoperability, when `previous_context` or `current_context` is present it MAY include the following keys. Each is OPTIONAL, because the corresponding notion may not exist in every deployment:

- `region` - The geographic or cloud region.
- `zone` - The availability or fault-isolation zone.
- `platform` - The runtime platform type (for example, `kubernetes`, `ecs`, `vm`, or `serverless`).
- `cluster` - An identifier for the orchestration cluster or scheduling domain.
- `image` - A reference or digest for the workload image or binary.

This set is the minimum interoperable capability: where a Receiver understands these keys, it can compare the prior and new environment without prior agreement. Both objects SHOULD use the same keys so they can be compared. The schema MAY be extended with additional deployment- or profile-specific topology information where a Transmitter sees fit; in that case the Transmitter is responsible for ensuring the Receiver can understand the added fields, and how such understanding is established is out of scope for this profile.

These fields can reveal workload infrastructure topology; see {{privacy-considerations}} for guidance on limiting the detail disclosed.

The following example is non-normative.

~~~ json
{
  "iss": "https://authority.example.com/",
  "jti": "wise-evt-030",
  "iat": 1700000000,
  "aud": "https://rp.partner.example.net/wise",
  "sub_id": {
    "format": "uri",
    "uri": "wimse://trust.example.com/workload/payment-service"
  },
  "events": {
    "https://schemas.openid.net/secevent/wise/event-type/workload-baseline-changed": {
      "reason": "migration",
      "previous_context": {
        "region": "us-east-1",
        "platform": "kubernetes"
      },
      "current_context": {
        "region": "eu-west-1",
        "platform": "kubernetes"
      },
      "posture_evaluation_status": "succeeded"
    }
  }
}
~~~
{: #fig-baseline-changed title="Example: Workload Baseline Changed (Migration)"}

### workload-compromised

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/workload-compromised`

The `workload-compromised` event signals that a workload is believed to be compromised based on runtime detection. This is a high-severity signal that SHOULD trigger immediate isolation or credential revocation. Where the Transmitter is also the credential authority for the workload, it SHOULD emit an accompanying `credential-revoked` event (with reason `compromise`), correlated using the `txn` claim as described in {{correlating-related-events}}.

Attributes:

- **detection_method** - OPTIONAL. How the compromise was detected.
- **event_timestamp** - OPTIONAL. Time of detection.

### anomalous-behavior-detected

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/anomalous-behavior-detected`

The `anomalous-behavior-detected` event signals that unusual behavior was observed for a workload. This is an advisory signal of lower severity than `workload-compromised`, intended for SIEM and SOC integration.

Attributes:

- **anomaly_type** - OPTIONAL. Category of the anomaly.
- **severity** - OPTIONAL. Severity level. Possible values:
    - `low`
    - `medium`
    - `high`
    - `critical`
- **event_timestamp** - OPTIONAL. Time of detection.

## Supply Chain Events

These events signal changes in a workload's supply chain including the provenance of the software it is built from and the vulnerability status of its components. The underlying detail such as a Software Bill of Materials (SBOM), a build attestation, or a vulnerability advisory is typically held in a separate document maintained by other tooling. These events act as signals that inform a relying party that something relevant has changed, and where to obtain the detail, rather than carrying the full supply-chain record inline.

### workload-provenance-changed

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/workload-provenance-changed`

The `workload-provenance-changed` event signals that the provenance of a workload, such as its SBOM or a build attestation has changed. This includes newly available or updated provenance, and the revocation or failed verification of previously trusted provenance. A relying party may re-evaluate its trust in the workload, or fetch the referenced document to assess the change.

Attributes:

- **change_type** - REQUIRED. The nature of the change. Possible values:
    - `updated` - New or updated provenance (for example, a new SBOM) is available.
    - `revoked` - Previously trusted provenance or an attestation is no longer valid.
    - `verification_failed` - Verification of the workload's provenance failed.
- **provenance_uri** - OPTIONAL. A URI at which the affected provenance document can be retrieved.
- **provenance_format** - OPTIONAL. A hint indicating the kind of document referenced, for example `sbom` or `attestation`.
- **artifact_digest** - OPTIONAL. A digest of the workload artifact (such as a container image) that the provenance describes, allowing the relying party to correlate the event with what is running.
- **event_timestamp** - OPTIONAL. The time the change occurred.

The following example is non-normative.

~~~ json
{
  "iss": "https://authority.example.com/",
  "jti": "wise-evt-040",
  "iat": 1700000000,
  "aud": "https://rp.partner.example.net/wise",
  "sub_id": {
    "format": "uri",
    "uri": "wimse://trust.example.com/workload/payment-service"
  },
  "events": {
    "https://schemas.openid.net/secevent/wise/event-type/workload-provenance-changed": {
      "change_type": "revoked",
      "provenance_uri": "https://provenance.example.com/payment-service/attestation",
      "reason_admin": {
        "en": "Build provenance attestation revoked by source repository owner"
      }
    }
  }
}
~~~
{: #fig-provenance-changed title="Example: Workload Provenance Changed"}

### workload-vulnerability-status-changed

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/workload-vulnerability-status-changed`

The `workload-vulnerability-status-changed` event signals a change in the status of a vulnerability with respect to a workload. The status values follow the Vulnerability Exploitability eXchange (VEX) model {{VEX}}, which distinguishes whether a workload is actually affected by a known vulnerability. This allows a transmitter both to warn a relying party that a workload has become affected, and to relax a prior warning when a vulnerability is found not to apply or has been fixed.

Attributes:

- **vulnerability_id** - REQUIRED. A public identifier for the vulnerability, such as a CVE identifier.
- **status** - REQUIRED. The status of the workload with respect to the vulnerability, following the VEX model {{VEX}}. Possible values:
    - `affected` - Actions are recommended to remediate or address the vulnerability.
    - `not_affected` - No remediation is required (for example, the vulnerable code is not reachable).
    - `fixed` - This workload contains a fix for the vulnerability.
    - `under_investigation` - Whether the workload is affected is not yet known.
- **severity** - OPTIONAL. A qualitative severity to help the relying party prioritise. Possible values: `low`, `medium`, `high`, `critical`.
- **advisory_uri** - OPTIONAL. A URI at which a full advisory or VEX statement can be retrieved.
- **event_timestamp** - OPTIONAL. The time the status changed.

The following example is non-normative.

~~~ json
{
  "iss": "https://authority.example.com/",
  "jti": "wise-evt-041",
  "iat": 1700000000,
  "aud": "https://rp.partner.example.net/wise",
  "sub_id": {
    "format": "uri",
    "uri": "wimse://trust.example.com/workload/payment-service"
  },
  "events": {
    "https://schemas.openid.net/secevent/wise/event-type/workload-vulnerability-status-changed": {
      "vulnerability_id": "CVE-2026-12345",
      "status": "affected",
      "severity": "critical",
      "advisory_uri": "https://advisories.example.com/CVE-2026-12345"
    }
  }
}
~~~
{: #fig-vulnerability-status-changed title="Example: Workload Vulnerability Status Changed"}

# Subject Identifiers for Workload Events

Following the Shared Signals Framework {{SSF}}, every WISE event conveys its subject in a top-level `sub_id` claim — a sibling of `iss`, `jti`, `iat`, `aud`, and `events`, not a member of the event-specific payload. The value of `sub_id` is a Subject Identifier as defined in {{RFC9493}}. WISE uses the `uri` format, carrying a Workload Identifier expressed as a URI following {{WIMSE-ID}}.

## URI Format

The `uri` format is the primary subject identifier format for WISE events. It carries the Workload Identifier as defined in {{WIMSE-ID}}, which is a URI containing a trust domain in the authority component and a workload-specific path.

The following example is non-normative.

~~~ json
{
  "format": "uri",
  "uri": "wimse://trust.example.com/workload/payment-service"
}
~~~

Deployments using SPIFFE identifiers {{SPIFFE}} express the subject using the `spiffe` URI scheme:

The following example is non-normative.

~~~ json
{
  "format": "uri",
  "uri": "spiffe://trust.example.com/ns/production/sa/payment-service"
}
~~~

Deployments using OAuth 2.0 Client ID Metadata Documents {{CIMD}} may express the workload subject using the client identifier URI:

The following example is non-normative.

~~~ json
{
  "format": "uri",
  "uri": "https://client.example.com/.well-known/oauth-client"
}
~~~

## Trust Domain Subject

For events that apply to an entire trust domain rather than to a single workload — the `trust-anchor-*` and `trust-domain-federation-*` events, and the policy events (`issuance-policy-changed`, `posture-evaluation-policy-changed`, `validation-policy-changed`) — the `sub_id` identifies the trust domain itself using its Workload Identifier Origin as defined in {{WIMSE-ID}}:

The following example is non-normative.

~~~ json
{
  "format": "uri",
  "uri": "wimse://trust.example.com"
}
~~~

# Security Considerations

## Confidentiality

WISE events MAY contain sensitive information about workload infrastructure topology, credential identifiers, and security posture. All network requests in this protocol MUST use TLS, and the use of TLS MUST follow the recommendations in {{RFC9325}}. Events SHOULD be encrypted using JSON Web Encryption (JWE) {{RFC7516}} when transmitted across trust domain boundaries.

## Replay and Freshness

Receivers MUST validate the `iat` claim and reject events that are unreasonably old. Receivers SHOULD maintain a record of recently received `jti` values to detect replay attacks.

## Authorization

Access to WISE event streams MUST be authorized. Transmitters MUST verify that Receivers are authorized to receive events for the specified subjects. A trust domain authority SHOULD NOT transmit workload-level events to parties that have no trust relationship with those workloads.

## Compromise Response

Several WISE events indicate that a credential, key, trust anchor, federation, or workload can no longer be trusted. This is signalled either by an event whose purpose is to report compromise (`credential-compromise`, `workload-compromised`) or by any event carrying a `reason` of `compromise` or `key_compromise`. Upon receiving any such event — regardless of event type, including events defined by future revisions or profiling specifications — Receivers SHOULD take immediate action appropriate to the affected object (for example, reject the affected credentials, keys, or trust material, or isolate the affected workload) without waiting for additional confirmation.

Events in this document that carry such a signal include `credential-compromise`; `credential-revoked` (with reason `compromise` or `key_compromise`); `trust-anchor-rotated` and `trust-anchor-revoked` (with reason `compromise`); `trust-domain-federation-revoked` (with reason `compromise`); `workload-disabled` (with reason `compromise`); and `workload-compromised`.

Rejecting credentials only takes effect at the next credential check or proof-of-possession step; neither short credential lifetime nor condition-liveness severs a connection that is already established. A Receiver that holds active connections with, or is actively serving, the affected workload SHOULD therefore also terminate those connections rather than waiting for the next operation. This is best-effort and applies to Receivers, such as gateways or service mesh components, that are able to correlate the workload identifier to live connections.

## Relationship to Credential Freshness Models

Deployments use different mechanisms to limit the exposure window of a compromised or deprovisioned workload:

- Issuer-side status signalling, where the trust domain authority communicates lifecycle changes to relying parties through an event channel. The events defined in this specification serve this purpose.
- Short credential lifetime, where the remaining validity period bounds the exposure window. In the WIMSE model, credentials are intentionally short-lived to force posture evaluation before re-issuance.
- Condition-liveness, as realised by condition-bounded credentials {{WIMSE-CBC}}, where a locally observable condition (hardware release policy, TEE state, platform integrity measurement) gates each key operation. Failure of the condition prevents the next presentation or handshake step without requiring a remote signal.

These mechanisms are complementary, not mutually exclusive. Condition-bounded credentials {{WIMSE-CBC}} remove the local deprovisioning window for conditions the endpoint can evaluate itself, but cannot observe externally originated changes: issuer policy withdrawal, trust anchor rotation, cross-domain incident response, or administrative decisions to terminate an established connection. WISE events address these cases. Deployments combining short-lived credentials with condition-liveness properties still benefit from issuer-side signalling for lifecycle changes that no local mechanism can detect.

## Supply Chain Signals

Supply chain events are advisory inputs to a Receiver's own decision-making. A Receiver SHOULD treat a `workload-vulnerability-status-changed` event as information to be evaluated against its own policies, rather than as a directive to be enforced automatically. In particular, a Receiver SHOULD NOT block, revoke, or otherwise restrict a workload's access solely because such an event was received. It SHOULD weigh the event together with the referenced advisory, the reported status and severity, and its own risk posture before deciding what action, if any, to take. A `revoked` provenance change, once validated, indicates that the affected provenance MUST NOT be relied upon.

# Privacy Considerations

WISE events may reveal information about internal infrastructure, deployment patterns, scaling behavior, and security incidents. Transmitters SHOULD minimize the information disclosed to what is necessary for the Receiver to take appropriate action.

Several fields in this specification carry free-form or descriptive values — for example `key_storage_ecosystem` on `credential-issued`, and `previous_context` / `current_context` on `workload-baseline-changed`. Such fields can inadvertently disclose fine-grained infrastructure or device detail, such as node or host names, IP addresses, internal network identifiers, device models, or software versions. For any such field, a Transmitter SHOULD avoid including detail beyond what the Receiver needs, based on its own evaluation of the privacy risk, particularly for events that may cross a trust-domain boundary. For example, a coarse `region` is preferable to a specific node or host name.

Events SHOULD NOT include personally identifiable information. Workload identifiers SHOULD NOT encode information about the humans who manage or operate the workloads.

# IANA Considerations

This specification defines no new IANA registrations. Event Type URIs are registered under the OpenID Foundation namespace.

--- back

# Acknowledgments
{:numbered="false"}

The authors would like to thank the members of the OpenID Foundation Shared Signals Working Group and the IETF WIMSE Working Group for their contributions to this specification.

# Document History
{:numbered="false"}

-03

- Completed the trust and federation lifecycle. Split the omnibus `trust-anchor-changed` event into explicit `trust-anchor-added`, `trust-anchor-rotated`, and `trust-anchor-revoked` events, and added `trust-domain-federation-established` and `trust-domain-federation-updated` to complement `trust-domain-federation-revoked`.
- Added an optional `key_details` object (`type`, `name`, `use`, aligned with the IANA JOSE registries) to `trust-anchor-added`, supporting the addition of a new algorithm (e.g., ECDSA alongside RSA) without rotation.
- Added an informative reference for condition-bounded credentials and cited it in the credential freshness models discussion.
- Corrected the description of condition-liveness to state that it removes (rather than reduces) the local deprovisioning window for conditions the endpoint can evaluate itself.
- Noted in Compromise Response that credential rejection only takes effect at the next operation, so Receivers holding active connections with an affected workload should also terminate them (best-effort).
- Added a general "Correlating Related Events" rule: a Transmitter SHOULD set a shared `txn` claim across all SETs describing one underlying occurrence, regardless of event type (replacing the per-event guidance). Added conditional pairing guidance to `workload-compromised`.
- Generalised the Compromise Response rule to apply to any event carrying a `compromise` or `key_compromise` signal, rather than an enumerated list of event types.
- Defined a minimal interoperable key set (`region`, `zone`, `platform`, `cluster`, `image`, each optional) for the `previous_context`/`current_context` fields of `workload-baseline-changed`, and allowed profile-specific extension.
- Added a single Privacy Considerations note covering over-disclosure in all free-form/descriptive fields (`key_storage_ecosystem`, `previous_context`, `current_context`), replacing per-field guidance.
- Clarified the distinction between `credential-renewal-failure` (operational outcome, multiple causes) and `posture-evaluation-failed` (a security-critical signal in its own right), and how the two relate when posture is the cause of a renewal failure.
- Made `reason_admin`/`reason_user` usage consistent: removed the redundant per-event listings and rely on the Common Optional Claims section, which now states the claims are not repeated per event and any event MAY carry them.
- Replaced the free-form `change_description` field on `trust-domain-federation-updated` and the policy-change events with the localizable `reason_admin`/`reason_user` common claims, for consistency with the CAEP-aligned pattern.
- Carried the subject in the top-level `sub_id` claim (RFC 9493 format, per SSF) instead of a nonstandard nested `subject` member, updating every example; and specified that policy events take the trust-domain subject.

-02

- Removed the Bound Key Lifecycle Events (`bound-key-issued`, `bound-key-rotated`, `bound-key-revoked`); key compromise and rotation are now handled through the credential events, and a `key_compromise` reason was added to `credential-revoked`. The `key_storage` and `key_storage_ecosystem` attributes moved to `credential-issued`.
- Aligned terminology with the WIMSE architecture: replaced "Identity Server" with "Credential Service", and "machine identity lifecycle" with "workload identity lifecycle".
- Softened the single-authority language and aligned it with WIMSE (a trust domain maps to one or more trust anchors).
- Renamed "Workload Identity State Events" to "Workload Lifecycle Events" and clarified that credential cancellation and issuance are conveyed by separate companion events.
- Added a "Common Optional Claims" section aligning `reason_admin`, `reason_user`, and `initiating_entity` with CAEP as localizable objects.
- Promoted RISC to a normative reference and refreshed the RISC, CAEP, and SSF references to their final 1.0 versions.
- Added normative references for WPT, RFC 5646, RFC 7523, RFC 8705, and RFC 9325, and cited RFC 7517 for the JWK Set.
- Replaced the TLS 1.2 requirement with a normative reference to the TLS recommendations in RFC 9325.
- Normalized enum values to use underscores while keeping event type names hyphenated.

-01

- Added Supply Chain Events

-00

- Initial draft.

