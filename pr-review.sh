#!/usr/bin/env bash
set -euo pipefail

# Configuration
MODEL="llama3.1:8b" # Swap to deepseek-r1:8b or qwen2.5-coder if preferred
TARGET_BRANCH="main"

# Get changes between current branch and target branch
DIFF="$(git diff "$TARGET_BRANCH"...HEAD)"

if [ -z "$DIFF" ]; then
  echo "✅ No changes found between HEAD and $TARGET_BRANCH."
  exit 0
fi

# Define the system instructions for the LLM
SYSTEM_PROMPT="You are a senior staff engineer performing a thorough PR code review.
Analyze the following git diff. Identify potential bugs, logical errors, security flaws, performance bottlenecks, or clean code violations.
Provide clear, actionable feedback. Group your feedback by file or severity. If everything looks clean, state that explicitly."

echo "🤖 Analyzing diff against '$TARGET_BRANCH' using Ollama ($MODEL)..."
echo "------------------------------------------------------------"

# Send both the system prompt and the code diff to Ollama
ollama run "$MODEL" "$SYSTEM_PROMPT\n\nCode Diff:\n$DIFF" > review_feedback.md
