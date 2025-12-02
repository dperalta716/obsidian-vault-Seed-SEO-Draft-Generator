---
name: google-gmail
description: This skill should be used for Gmail operations including searching emails, reading messages, sending emails, managing labels, and organizing inbox workflows. Use when working with email automation, daily email summaries, or any Gmail-related tasks.
---

# Google Gmail Skill

Provides comprehensive access to Gmail API v1 for email management, search, and automation workflows.

## When to Use This Skill

Trigger this skill for email-related tasks such as:
- Searching and filtering Gmail messages
- Reading email content and threads
- Sending emails or creating drafts
- Managing labels and organizing messages
- Archiving, trashing, or deleting messages
- Daily email summary workflows
- Bulk email operations
- Thread management

## Available Operations

### Message Search & Retrieval

#### 1. Search Messages
Search Gmail using query syntax.

**Usage:**
```bash
./scripts/search-messages.sh "user@example.com" "is:unread from:example@domain.com" [page_size]
```

**Parameters:**
- `user_email` - User's Gmail address (required)
- `query` - Gmail search query (required)
- `page_size` - Max results to return (optional, default: 10)

**Query Examples:**
- `"is:unread"` - All unread messages
- `"from:sender@example.com"` - Messages from specific sender
- `"after:2025/10/20"` - Messages after date
- `"in:inbox after:2025/10/22"` - Recent inbox messages
- `"subject:invoice"` - Messages with "invoice" in subject

**Returns:** JSON with message IDs and thread IDs

#### 2. Get Message Content
Retrieve full content of a single message.

**Usage:**
```bash
./scripts/get-message.sh "user@example.com" "message_id"
```

**Returns:** JSON with parsed message including:
- `id` - Message ID
- `threadId` - Thread ID
- `from` - Sender email
- `to` - Recipient email
- `subject` - Email subject
- `date` - Date sent
- `body` - Plain text body content
- `labels` - Applied label IDs

#### 3. Get Messages Batch
Retrieve multiple messages in one operation.

**Usage:**
```bash
./scripts/get-messages-batch.sh "user@example.com" "msg_id1,msg_id2,msg_id3"
```

**Parameters:**
- `user_email` - User's Gmail address
- `message_ids` - Comma-separated list of message IDs

**Returns:** JSON array of parsed messages

**Note:** Automatically handles batching to avoid SSL connection limits

### Thread Operations

#### 4. Get Thread Content
Retrieve entire email thread with all messages.

**Usage:**
```bash
./scripts/get-thread.sh "user@example.com" "thread_id"
```

**Returns:** JSON with:
- `threadId` - Thread ID
- `messageCount` - Number of messages in thread
- `messages` - Array of all messages with full content

#### 5. Get Threads Batch
Retrieve multiple threads in one operation.

**Usage:**
```bash
./scripts/get-threads-batch.sh "user@example.com" "thread_id1,thread_id2,thread_id3"
```

**Returns:** JSON array of threads with all messages

### Sending & Drafting

#### 6. Send Message
Send an email via Gmail.

**Usage:**
```bash
./scripts/send-message.sh "user@example.com" "to@example.com" "Subject" "Body text" [cc] [bcc] [thread_id] [in_reply_to] [references] [from_name]
```

**Parameters:**
- `user_email` - Sender's Gmail address (required)
- `to` - Recipient email (required)
- `subject` - Email subject (required)
- `body` - Email body text (required)
- `cc` - CC recipients (optional)
- `bcc` - BCC recipients (optional)
- `thread_id` - Thread ID for replies (optional)
- `in_reply_to` - Message-ID being replied to (optional)
- `references` - Chain of Message-IDs for threading (optional)
- `from_name` - Custom display name for sender (optional, e.g., "David Peralta")

**Example - Simple Email:**
```bash
./scripts/send-message.sh "david@david-peralta.com" "recipient@example.com" "Meeting Tomorrow" "Hi, let's meet at 2pm."
```

**Example - Email with Display Name:**
```bash
./scripts/send-message.sh "david@david-peralta.com" "recipient@example.com" "Meeting Tomorrow" "Hi, let's meet at 2pm." "" "" "" "" "" "David Peralta"
```

**Example - Reply in Thread:**
```bash
./scripts/send-message.sh "david@david-peralta.com" "recipient@example.com" "Re: Project Update" "Thanks for the update!" "" "" "thread_abc123" "<message123@gmail.com>" "<original@gmail.com> <message123@gmail.com>"
```

**Returns:** JSON with sent message ID and thread ID

#### 7. Create Draft
Create a draft email without sending.

**Usage:**
```bash
./scripts/draft-message.sh "user@example.com" "to@example.com" "Subject" "Body text" [cc] [bcc] [thread_id] [in_reply_to] [references] [from_name]
```

**Parameters:** Same as send-message.sh

**Returns:** JSON with draft ID and message details

### Label Management

#### 8. List Labels
Get all labels in the Gmail account.

**Usage:**
```bash
./scripts/list-labels.sh "user@example.com"
```

**Returns:** JSON array of labels with:
- `id` - Label ID
- `name` - Label name
- `type` - Label type (system or user)
- `messageListVisibility` - Visibility setting
- `labelListVisibility` - List visibility setting

**System Labels:** INBOX, SENT, DRAFT, SPAM, TRASH, UNREAD, STARRED, IMPORTANT

#### 9. Manage Label
Create, update, or delete labels.

**Usage - Create Label:**
```bash
./scripts/manage-label.sh "user@example.com" "create" "My New Label"
```

**Usage - Update Label:**
```bash
./scripts/manage-label.sh "user@example.com" "update" "Updated Name" "Label_123" "show" "labelShow"
```

**Usage - Delete Label:**
```bash
./scripts/manage-label.sh "user@example.com" "delete" "" "Label_123"
```

**Parameters:**
- `user_email` - User's Gmail address
- `action` - create, update, or delete
- `name` - Label name (required for create, optional for update)
- `label_id` - Label ID (required for update/delete)
- `message_list_visibility` - show or hide (optional, default: show)
- `label_list_visibility` - labelShow or labelHide (optional, default: labelShow)

#### 10. Modify Message Labels
Add or remove labels from a single message.

**Usage:**
```bash
./scripts/modify-message-labels.sh "user@example.com" "message_id" "Label_1,Label_2" "INBOX,UNREAD"
```

**Parameters:**
- `user_email` - User's Gmail address
- `message_id` - Message ID to modify
- `add_label_ids` - Comma-separated label IDs to add
- `remove_label_ids` - Comma-separated label IDs to remove

**Common Operations:**
- Archive: Remove INBOX label
- Mark unread: Add UNREAD label
- Mark read: Remove UNREAD label
- Star: Add STARRED label
- Move to folder: Add custom label, remove INBOX

#### 11. Batch Modify Labels
Modify labels on multiple messages at once.

**Usage:**
```bash
./scripts/batch-modify-labels.sh "user@example.com" "msg_id1,msg_id2,msg_id3" "Label_1" "INBOX"
```

**Parameters:**
- `user_email` - User's Gmail address
- `message_ids` - Comma-separated message IDs
- `add_label_ids` - Labels to add (comma-separated)
- `remove_label_ids` - Labels to remove (comma-separated)

**Returns:** Success message with count of modified messages

#### 12. Modify Thread Labels
Modify labels on all messages in a thread.

**Usage:**
```bash
./scripts/modify-thread-labels.sh "user@example.com" "thread_id" "Label_1" "INBOX"
```

**Parameters:** Same as modify-message-labels.sh but operates on threads

### Message Lifecycle

#### 13. Archive Message
Remove message from inbox (convenience wrapper).

**Usage:**
```bash
./scripts/archive-message.sh "user@example.com" "message_id"
```

**Effect:** Removes INBOX label, message moves to All Mail

#### 14. Trash Message
Move message to trash (recoverable).

**Usage:**
```bash
./scripts/trash-message.sh "user@example.com" "message_id"
```

**Effect:** Message moves to Trash, can be recovered with untrash

#### 15. Untrash Message
Restore message from trash.

**Usage:**
```bash
./scripts/untrash-message.sh "user@example.com" "message_id"
```

**Effect:** Removes TRASH label, restores to previous state

#### 16. Delete Message
Permanently delete a message.

**Usage:**
```bash
./scripts/delete-message.sh "user@example.com" "message_id"
```

**Warning:** Permanent deletion, cannot be recovered

#### 17. Batch Delete
Permanently delete multiple messages at once.

**Usage:**
```bash
./scripts/batch-delete.sh "user@example.com" "msg_id1,msg_id2,msg_id3"
```

**Returns:** Success message with count of deleted messages

## Authentication

All scripts automatically extract OAuth tokens from the shared credential store at:
```
~/.claude/skills/google-workspace-credentials/{user_email}.json
```

The authentication library (`scripts/lib/auth.sh`) handles:
- Reading access tokens from credential file
- Automatic token refresh when expired
- Updating credential file with new tokens
- Error handling for missing or invalid credentials

**Token Refresh:** Access tokens expire after ~1 hour. Scripts automatically detect expiration and refresh tokens using the refresh_token stored in the credential file.

**Independence:** This skill is completely independent from the Google Workspace MCP server. Credentials are stored and managed separately.

## MIME Encoding

Email sending and reading requires MIME message encoding. The `scripts/lib/mime.sh` library provides:

**Encoding (for sending):**
- Builds RFC-compliant MIME messages
- Handles To, CC, BCC, Subject headers
- Supports In-Reply-To and References for threading
- Base64url encodes message for Gmail API

**Decoding (for reading):**
- Parses both single-part and multipart messages
- Extracts plain text body content
- Falls back to HTML if plain text unavailable
- Handles base64url decoding

## Common Workflows

### Daily Email Summary
Search recent inbox messages, read content, and archive:

```bash
# Search for recent messages
RESULTS=$(./scripts/search-messages.sh "user@example.com" "in:inbox after:2025/10/22")

# Extract message IDs
MESSAGE_IDS=$(echo "$RESULTS" | jq -r '.messages[].id' | paste -sd, -)

# Get all messages in batch
MESSAGES=$(./scripts/get-messages-batch.sh "user@example.com" "$MESSAGE_IDS")

# Archive each message
for MSG_ID in $(echo "$MESSAGE_IDS" | tr ',' ' '); do
  ./scripts/archive-message.sh "user@example.com" "$MSG_ID"
done
```

### Send Email with Reply Threading
Maintain proper thread context when replying:

```bash
# Get original message
ORIGINAL=$(./scripts/get-message.sh "user@example.com" "msg_abc123")
THREAD_ID=$(echo "$ORIGINAL" | jq -r '.threadId')

# Send reply in thread
./scripts/send-message.sh \
  "user@example.com" \
  "sender@example.com" \
  "Re: Original Subject" \
  "Thanks for your message!" \
  "" "" \
  "$THREAD_ID" \
  "<original-message-id@gmail.com>" \
  "<msg1@gmail.com> <msg2@gmail.com> <original-message-id@gmail.com>"
```

### Bulk Label Management
Apply labels to multiple messages matching a query:

```bash
# Search for messages
RESULTS=$(./scripts/search-messages.sh "user@example.com" "from:newsletter@example.com" 100)
MESSAGE_IDS=$(echo "$RESULTS" | jq -r '.messages[].id' | paste -sd, -)

# Apply label to all
./scripts/batch-modify-labels.sh \
  "user@example.com" \
  "$MESSAGE_IDS" \
  "Label_newsletters" \
  "INBOX"
```

## Error Handling

All scripts return JSON error objects when operations fail:

```json
{
  "error": {
    "code": 400,
    "message": "Invalid message ID",
    "status": "INVALID_ARGUMENT"
  }
}
```

Common errors:
- `401 Unauthorized` - Token expired (automatically refreshed)
- `404 Not Found` - Invalid message/thread/label ID
- `400 Bad Request` - Malformed query or parameters
- `403 Forbidden` - Insufficient permissions

Scripts exit with status code 1 on errors and output error JSON to stderr.

## API Documentation

Full Gmail API reference: https://developers.google.com/gmail/api/reference/rest

**Base URL:** `https://gmail.googleapis.com/gmail/v1`

**Scopes Required:**
- `https://www.googleapis.com/auth/gmail.modify` - Read, send, delete, and manage email
- `https://www.googleapis.com/auth/gmail.labels` - Manage labels (included in gmail.modify)

## Notes

- **Attachments:** This skill does not support email attachments. All operations work with plain text email bodies only.
- **Batch Limits:** Batch operations are limited to 25 items to prevent SSL connection issues
- **Threading:** Proper email threading requires In-Reply-To and References headers
- **System Labels:** Cannot be deleted or renamed (INBOX, SENT, TRASH, etc.)
- **Performance:** Batch operations are more efficient than individual calls for multiple messages
