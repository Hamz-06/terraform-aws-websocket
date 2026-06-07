# Terraform AWS WebSocket Module

[![Module Version](https://img.shields.io/github/v/release/Hamz-06/terraform-aws-websocket?label=module%20version)](https://github.com/Hamz-06/terraform-aws-websocket/releases)

Production-grade Terraform module for WebSocket messaging on AWS with 4 Lambda functions:

- connect
- disconnect
- default
- producer

This module is artifact-first and Terraform Cloud friendly:

- No local source-path packaging during terraform plan/apply
- Deterministic Lambda updates from immutable artifact references
- S3 zip artifacts only (one artifact contract for every deployment)

## Architecture

- API Gateway WebSocket API for connect/disconnect/default routes
- API Gateway HTTP API for producer endpoint
- DynamoDB table for connection tracking
- Lambda functions configured from immutable artifacts

## Deployment Contract

This module supports S3 zip artifacts only.

Each function must provide:

Each function must provide:

- `bucket`
- `key`
- `source_code_hash`

Optional:

- `object_version`

## Quick Start: s3_zip

```hcl
module "websocket" {
  source = "Hamz-06/websocket/aws"

  region                 = "us-east-1"
  application_name       = "my-websocket"
  stage_name             = "prod"

  lambdas = {
    connect = {
      s3 = {
        bucket           = "my-artifacts"
        key              = "websocket/connect/3b5e3f4a10f0aa1f92f2f9d57b8f95ea4d0b2d51.zip"
        source_code_hash = "fL6gpgVf9qx+fGx3xVj3wRxM7N3lX1fZzS9d9vK6FnI="
      }
    }
    disconnect = {
      s3 = {
        bucket           = "my-artifacts"
        key              = "websocket/disconnect/0bc8d8449f0ac91db1b6e7d72c2a2cba8f0a6dc8.zip"
        source_code_hash = "qR5kV7NnU0wB0WQk4fP4zplNvVQ0mFfSK0C8Qj2t+8I="
      }
    }
    default = {
      s3 = {
        bucket           = "my-artifacts"
        key              = "websocket/default/a3d6f3e3ed2e8dd87ffcf78d726cb5e4a85f7a9c.zip"
        source_code_hash = "3B30lCLkNiyL6rypFo5f4O6RkQAHv3tSq+yt1j3z2n8="
      }
    }
    producer = {
      s3 = {
        bucket           = "my-artifacts"
        key              = "websocket/producer/4d17a3af6ba78de1fbc7e4ecf4b8af53f91714bf.zip"
        source_code_hash = "N6F6iSkhbe9Y5Sp3h4q5b5NQ8xCWmS2YQ70zBf8n6Sg="
      }
    }
  }
}
```

## CI Artifact Contract

CI must publish immutable artifacts before Terraform runs.

- Upload one zip per function to S3
- Use immutable keys (commit SHA or content-addressed path)
- Compute and export base64-encoded SHA256 as `source_code_hash`
- Avoid mutable keys such as `latest.zip`

## Terraform Cloud Remote Run Note

This module does not package local Lambda source code and does not execute local build tooling during Terraform plan/apply.

Remote runs require only artifact metadata:

- S3 bucket/key/hash (and optional object version)

## Security and Quality Baseline

- CloudWatch log retention is configurable via `cloudwatch_logs_retention_in_days`
- Tags are propagated to all module-managed resources via `tags`
- Resource names are deterministic from `application_name` and function role
- IAM policy assumptions are least-privilege oriented for API invoke/manage-connections and DynamoDB CRUD

## Outputs

- WebSocket API endpoint and domain
- Producer HTTP API endpoint
- All 4 Lambda ARNs and invoke ARNs
- DynamoDB table name

## Examples

- `examples/s3-zip`
- `example` (single-folder s3_zip usage)

## Troubleshooting

### Missing source_code_hash

Error:

- `Each lambdas.<function>.s3 must include non-empty bucket, key, and source_code_hash.`

Fix:

- Provide `source_code_hash` for every function under `lambdas`.

## Commit Convention

Follow [semantic-release commit message format](https://semantic-release.gitbook.io/semantic-release#commit-message-format).