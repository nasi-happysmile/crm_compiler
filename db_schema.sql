"db": {
      "engine": "PostgreSQL 15",
      "tables": {
        "users": {
          "columns": {
            "id": "UUID PK DEFAULT gen_random_uuid()",
            "email": "VARCHAR(255) UNIQUE NOT NULL",
            "password_hash": "TEXT NOT NULL",
            "role": "ENUM('admin','manager','sales_rep','viewer') NOT NULL DEFAULT 'viewer'",
            "plan": "ENUM('free','premium') NOT NULL DEFAULT 'free'",
            "created_at": "TIMESTAMPTZ DEFAULT now()",
            "updated_at": "TIMESTAMPTZ DEFAULT now()"
          },
          "indexes": [
            "email"
          ]
        },
        "contacts": {
          "columns": {
            "id": "UUID PK DEFAULT gen_random_uuid()",
            "owner_id": "UUID FK→users.id",
            "name": "VARCHAR(255) NOT NULL",
            "email": "VARCHAR(255)",
            "phone": "VARCHAR(50)",
            "company": "VARCHAR(255)",
            "status": "ENUM('lead','prospect','customer','churned') DEFAULT 'lead'",
            "notes": "TEXT",
            "created_at": "TIMESTAMPTZ DEFAULT now()",
            "updated_at": "TIMESTAMPTZ DEFAULT now()"
          },
          "indexes": [
            "owner_id",
            "status",
            "company"
          ],
          "rls_policy": "sales_rep sees only WHERE owner_id = current_user_id"
        },
        "deals": {
          "columns": {
            "id": "UUID PK DEFAULT gen_random_uuid()",
            "contact_id": "UUID FK→contacts.id",
            "owner_id": "UUID FK→users.id",
            "stage": "ENUM('discovery','proposal','negotiation','closed_won','closed_lost')",
            "value": "DECIMAL(12,2)",
            "expected_close": "DATE",
            "created_at": "TIMESTAMPTZ DEFAULT now()"
          },
          "indexes": [
            "owner_id",
            "contact_id",
            "stage"
          ]
        },
        "subscriptions": {
          "columns": {
            "id": "UUID PK DEFAULT gen_random_uuid()",
            "user_id": "UUID FK→users.id UNIQUE",
            "stripe_customer_id": "TEXT",
            "stripe_subscription_id": "TEXT",
            "plan": "ENUM('free','premium')",
            "status": "ENUM('active','canceled','past_due')",
            "current_period_end": "TIMESTAMPTZ"
          },
          "indexes": [
            "user_id",
            "stripe_subscription_id"
          ]
        },
        "analytics_events": {
          "columns": {
            "id": "UUID PK DEFAULT gen_random_uuid()",
            "user_id": "UUID FK→users.id",
            "event_type": "VARCHAR(100)",
            "entity_type": "VARCHAR(50)",
            "entity_id": "UUID",
            "metadata": "JSONB",
            "occurred_at": "TIMESTAMPTZ DEFAULT now()"
          },
          "indexes": [
            "user_id",
            "event_type",
            "occurred_at"
          ],
          "note": "append-only event store; never update/delete"
        },
        "refresh_tokens": {
          "columns": {
            "id": "UUID PK DEFAULT gen_random_uuid()",
            "user_id": "UUID FK→users.id",
            "token_hash": "TEXT NOT NULL",
            "expires_at": "TIMESTAMPTZ NOT NULL",
            "revoked": "BOOLEAN DEFAULT false"
          },
          "indexes": [
            "token_hash",
            "user_id"
          ]
        }
      },
      "views": {
        "mrr_view": "SELECT DATE_TRUNC('month', current_period_end) AS month, COUNT(*)*29 AS mrr FROM subscriptions WHERE plan='premium' AND status='active' GROUP BY 1",
        "funnel_view": "SELECT stage, COUNT(*) AS count FROM deals GROUP BY stage ORDER BY ARRAY_POSITION(ARRAY['discovery','proposal','negotiation','closed_won','closed_lost'],stage)"
      }
    }
