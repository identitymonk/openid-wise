---
stand_alone: true
ipr: none
cat: std # Check
submissiontype: IETF
wg: OpenID Shared Signals

docname: openid-wise-profile-1_0

title: "OpenID WISE Profile Specification 1.0 - draft 02"
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
  org: Dendro
  email: dag@dendro.systems
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

## Common Optional Claims {#common-optional-claims}

Unless stated otherwise, any WISE event MAY include the common optional claims defined in Section 2 of {{CAEP}}. In particular:

- **reason_admin** - OPTIONAL. A localizable administrative message intended for logging and auditing, as defined in {{CAEP}}. Its value is a JSON object containing one or more key/value pairs, where each key is a BCP 47 {{RFC5646}} language tag and each value is the locale-specific message.
- **reason_user** - OPTIONAL. A localizable, user-facing message, as defined in {{CAEP}}. Its value follows the same JSON object structure as `reason_admin`.
- **initiating_entity** - OPTIONAL. A JSON string describing what triggered the event, as defined in {{CAEP}}: one of `admin`, `user`, `policy`, or `system`.

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
  "events": {
    "https://schemas.openid.net/secevent/wise/event-type/credential-issued": {
      "subject": {
        "format": "uri",
        "uri": "wimse://trust.example.com/workload/payment-service"
      },
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
  "events": {
    "https://schemas.openid.net/secevent/wise/event-type/credential-rotated": {
      "subject": {
        "format": "uri",
        "uri": "wimse://trust.example.com/workload/payment-service"
      },
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
  "events": {
    "https://schemas.openid.net/secevent/wise/event-type/credential-revoked": {
      "subject": {
        "format": "uri",
        "uri": "wimse://trust.example.com/workload/payment-service"
      },
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
- **reason_admin** - OPTIONAL. Localizable administrative description of the compromise, as defined in the Common Optional Claims ({{common-optional-claims}}).

The following example is non-normative.

~~~ json
{
  "iss": "https://authority.example.com/",
  "jti": "wise-evt-004",
  "iat": 1700000000,
  "aud": "https://rp.partner.example.net/wise",
  "events": {
    "https://schemas.openid.net/secevent/wise/event-type/credential-compromise": {
      "subject": {
        "format": "uri",
        "uri": "wimse://trust.example.com/workload/payment-service"
      },
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
  "events": {
    "https://schemas.openid.net/secevent/wise/event-type/credential-renewal-failure": {
      "subject": {
        "format": "uri",
        "uri": "wimse://trust.example.com/workload/payment-service"
      },
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

These events signal changes to the trust material that federated peers and relying parties use to validate workload identity credentials from a trust domain.

### trust-anchor-changed

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/trust-anchor-changed`

The `trust-anchor-changed` event signals that the trust anchors for a trust domain have changed. Relying parties and federated peers MUST update their validation material accordingly.

Attributes:

- **anchor_type** - REQUIRED. The type of trust material that changed. Possible values:
    - `x509_ca` - X.509 CA certificate(s) used to validate Workload Identity Certificates (WIC) or X.509-SVIDs.
    - `jwks` - JSON Web Key Set {{RFC7517}} used to validate Workload Identity Tokens (WIT).
- **change_type** - REQUIRED. The nature of the change. Possible values:
    - `key_added` - A new key or CA was added to the trust bundle.
    - `key_rotated` - An existing key or CA was replaced.
    - `key_revoked` - A key or CA was revoked and MUST no longer be trusted.
    - `key_expired` - A key or CA has expired.
    - `full_replacement` - The entire trust bundle was replaced.
- **trust_domain** - REQUIRED. The FQDN of the trust domain whose material changed.
- **effective_at** - OPTIONAL. When the new material becomes (or became) active. JSON number (NumericDate).
- **old_material_expiry** - OPTIONAL. When the old material will cease to be valid (grace period end). JSON number (NumericDate).
- **jwks_uri** - OPTIONAL. When `anchor_type` is `jwks`, the URI to fetch the updated JWK Set.
- **x509_bundle_uri** - OPTIONAL. When `anchor_type` is `x509_ca`, the URI to fetch the updated CA bundle.
- **key_id** - OPTIONAL. The specific key affected. For JWKS, the `kid` value. For X.509, the certificate serial number or Subject Key Identifier.
- **reason** - OPTIONAL. Why the change was made. Possible values:
    - `scheduled_rotation` - Routine key rotation.
    - `compromise` - A key or CA is believed compromised.
    - `policy_change` - Changed due to updated security policy.
    - `expiry` - Proactive rotation before scheduled expiry.

The following example is non-normative.

~~~ json
{
  "iss": "https://authority.example.com/",
  "jti": "wise-evt-020",
  "iat": 1700000000,
  "aud": "https://federation-peer.example.net/wise",
  "events": {
    "https://schemas.openid.net/secevent/wise/event-type/trust-anchor-changed": {
      "subject": {
        "format": "uri",
        "uri": "wimse://trust.example.com"
      },
      "anchor_type": "jwks",
      "change_type": "key_rotated",
      "trust_domain": "trust.example.com",
      "effective_at": 1700000000,
      "old_material_expiry": 1700604800,
      "jwks_uri": "https://authority.example.com/.well-known/jwks.json",
      "key_id": "kid:signing-2024-q4",
      "reason": "scheduled_rotation"
    }
  }
}
~~~
{: #fig-trust-anchor-jwks title="Example: Trust Anchor Changed (JWKS Rotation)"}

The following example is non-normative.

~~~ json
{
  "iss": "https://authority.example.com/",
  "jti": "wise-evt-021",
  "iat": 1700000000,
  "aud": "https://federation-peer.example.net/wise",
  "events": {
    "https://schemas.openid.net/secevent/wise/event-type/trust-anchor-changed": {
      "subject": {
        "format": "uri",
        "uri": "wimse://trust.example.com"
      },
      "anchor_type": "x509_ca",
      "change_type": "key_revoked",
      "trust_domain": "trust.example.com",
      "key_id": "serial:CA-ROOT-2023-001",
      "reason": "compromise"
    }
  }
}
~~~
{: #fig-trust-anchor-x509 title="Example: Trust Anchor Changed (CA Compromise)"}

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
- **change_description** - OPTIONAL. Human-readable description of the change.
- **effective_at** - OPTIONAL. When the new policy takes effect.
- **event_timestamp** - OPTIONAL. Time the change was made.

### posture-evaluation-policy-changed

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/posture-evaluation-policy-changed`

The `posture-evaluation-policy-changed` event signals that the posture evaluation policy has changed. This may affect which evidence is required from workloads, what evaluation criteria apply, or what deployment context signals are considered during credential issuance and renewal.

Attributes:

- **policy_id** - OPTIONAL. Identifier of the policy that changed.
- **change_description** - OPTIONAL. Human-readable description.
- **effective_at** - OPTIONAL. When the new policy takes effect.
- **event_timestamp** - OPTIONAL. Time the change was made.

### validation-policy-changed

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/validation-policy-changed`

The `validation-policy-changed` event signals that the policy used to validate workload identity credentials at relying parties has changed. This includes changes to trust anchor validation rules, claim validation requirements, audience restrictions, or acceptable credential types.

Attributes:

- **policy_id** - OPTIONAL. Identifier of the policy that changed.
- **change_description** - OPTIONAL. Human-readable description.
- **effective_at** - OPTIONAL. When the new policy takes effect.
- **event_timestamp** - OPTIONAL. Time the change was made.

### posture-evaluation-failed

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/posture-evaluation-failed`

The `posture-evaluation-failed` event signals that a workload did not pass posture evaluation. The Credential Service determined that the workload's runtime environment, software integrity, or deployment context did not meet the requirements for credential issuance.

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
- **previous_context** - OPTIONAL. JSON object describing the prior environment metadata (structure defined by implementation).
- **current_context** - OPTIONAL. JSON object describing the new environment metadata.
- **posture_evaluation_status** - OPTIONAL. Whether posture re-evaluation has occurred. Possible values:
    - `succeeded` - Re-evaluation completed successfully.
    - `pending` - Re-evaluation has not yet occurred.
    - `failed` - Re-evaluation was attempted and failed.
- **event_timestamp** - OPTIONAL. Time of the change.

The following example is non-normative.

~~~ json
{
  "iss": "https://authority.example.com/",
  "jti": "wise-evt-030",
  "iat": 1700000000,
  "aud": "https://rp.partner.example.net/wise",
  "events": {
    "https://schemas.openid.net/secevent/wise/event-type/workload-baseline-changed": {
      "subject": {
        "format": "uri",
        "uri": "wimse://trust.example.com/workload/payment-service"
      },
      "reason": "migration",
      "previous_context": {
        "region": "us-east-1",
        "node": "node-abc"
      },
      "current_context": {
        "region": "eu-west-1",
        "node": "node-xyz"
      },
      "posture_evaluation_status": "succeeded"
    }
  }
}
~~~
{: #fig-baseline-changed title="Example: Workload Baseline Changed (Migration)"}

### workload-compromised

Event Type URI: `https://schemas.openid.net/secevent/wise/event-type/workload-compromised`

The `workload-compromised` event signals that a workload is believed to be compromised based on runtime detection. This is a high-severity signal that SHOULD trigger immediate isolation or credential revocation.

Attributes:

- **detection_method** - OPTIONAL. How the compromise was detected.
- **reason_admin** - OPTIONAL. Localizable administrative description, as defined in the Common Optional Claims ({{common-optional-claims}}).
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
- **reason_admin** - OPTIONAL. Localizable administrative description, as defined in the Common Optional Claims ({{common-optional-claims}}).
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
- **reason_admin** - OPTIONAL. Localizable administrative description of the change, as defined in the Common Optional Claims ({{common-optional-claims}}).
- **event_timestamp** - OPTIONAL. The time the change occurred.

The following example is non-normative.

~~~ json
{
  "iss": "https://authority.example.com/",
  "jti": "wise-evt-040",
  "iat": 1700000000,
  "aud": "https://rp.partner.example.net/wise",
  "events": {
    "https://schemas.openid.net/secevent/wise/event-type/workload-provenance-changed": {
      "subject": {
        "format": "uri",
        "uri": "wimse://trust.example.com/workload/payment-service"
      },
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
- **reason_admin** - OPTIONAL. Localizable administrative description, as defined in the Common Optional Claims ({{common-optional-claims}}).
- **event_timestamp** - OPTIONAL. The time the status changed.

The following example is non-normative.

~~~ json
{
  "iss": "https://authority.example.com/",
  "jti": "wise-evt-041",
  "iat": 1700000000,
  "aud": "https://rp.partner.example.net/wise",
  "events": {
    "https://schemas.openid.net/secevent/wise/event-type/workload-vulnerability-status-changed": {
      "subject": {
        "format": "uri",
        "uri": "wimse://trust.example.com/workload/payment-service"
      },
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

WISE events use subject identifiers as defined in {{RFC9493}}. Workload identities in the WIMSE model are expressed as URIs following the format defined in {{WIMSE-ID}}.

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

For events that apply to an entire trust domain (e.g., `trust-anchor-changed`, `trust-domain-federation-revoked`), the subject identifies the trust domain itself using its Workload Identifier Origin as defined in {{WIMSE-ID}}:

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

Upon receiving a `credential-compromise`, `credential-revoked` (with reason `compromise` or `key_compromise`), `trust-anchor-changed` (with reason `compromise`), or `workload-compromised` event, Receivers SHOULD take immediate action to reject the affected credentials, keys, or trust material without waiting for additional confirmation.

## Relationship to Credential Freshness Models

Deployments use different mechanisms to limit the exposure window of a compromised or deprovisioned workload:

- Issuer-side status signalling, where the trust domain authority communicates lifecycle changes to relying parties through an event channel. The events defined in this specification serve this purpose.
- Short credential lifetime, where the remaining validity period bounds the exposure window. In the WIMSE model, credentials are intentionally short-lived to force posture evaluation before re-issuance.
- Condition-liveness, where a locally observable condition (hardware release policy, TEE state, platform integrity measurement) gates each key operation. Failure of the condition prevents the next presentation or handshake step without requiring a remote signal.

These mechanisms are complementary, not mutually exclusive. Condition-bounded credentials reduce the local deprovisioning window but cannot observe externally originated changes: issuer policy withdrawal, trust anchor rotation, cross-domain incident response, or administrative decisions to terminate an established connection. WISE events address these cases. Deployments combining short-lived credentials with condition-liveness properties still benefit from issuer-side signalling for lifecycle changes that no local mechanism can detect.

## Supply Chain Signals

Supply chain events are advisory inputs to a Receiver's own decision-making. A Receiver SHOULD treat a `workload-vulnerability-status-changed` event as information to be evaluated against its own policies, rather than as a directive to be enforced automatically. In particular, a Receiver SHOULD NOT block, revoke, or otherwise restrict a workload's access solely because such an event was received. It SHOULD weigh the event together with the referenced advisory, the reported status and severity, and its own risk posture before deciding what action, if any, to take. A `revoked` provenance change, once validated, indicates that the affected provenance MUST NOT be relied upon.

# Privacy Considerations

WISE events may reveal information about internal infrastructure, deployment patterns, scaling behavior, and security incidents. Transmitters SHOULD minimize the information disclosed to what is necessary for the Receiver to take appropriate action.

Events SHOULD NOT include personally identifiable information. Workload identifiers SHOULD NOT encode information about the humans who manage or operate the workloads.

# IANA Considerations

This specification defines no new IANA registrations. Event Type URIs are registered under the OpenID Foundation namespace.

--- back

# Acknowledgments
{:numbered="false"}

The authors would like to thank the members of the OpenID Foundation Shared Signals Working Group and the IETF WIMSE Working Group for their contributions to this specification.

# Document History
{:numbered="false"}

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

