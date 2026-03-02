---
name: ck:ai-multimodal
description: Analyze images/audio/video with Gemini API (better vision than Claude). Generate images (Imagen 4), videos (Veo 3). Use for vision analysis, transcription, OCR, design extraction, multimodal AI.
license: MIT
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
argument-hint: "[file-path] [prompt]"
---

# /ai-multimodal — Gemini Multimodal Analysis + Generation

Process images, audio, video, documents; generate images/videos via Google Gemini.

## Usage

When to use: image analysis, OCR, transcription, design extraction, video analysis, image/video generation.

## Quick Start

```bash
# Check if gemini CLI available — preferred for image analysis
echo "<prompt>" | gemini -y -m <gemini.model>  # model from $HOME/.claude/.ck.json

# Otherwise use Python scripts
python scripts/gemini_batch_process.py --files <file> --task <analyze|transcribe|extract>
python scripts/gemini_batch_process.py --task <generate|generate-video> --prompt "description"
python scripts/check_setup.py  # verify setup
```

## Models

- Image generation: `imagen-4.0-generate-001` (standard), `-ultra-` (quality), `-fast-` (speed)
- Video generation: `veo-3.1-generate-preview` (8s clips with audio)
- Analysis: `gemini-2.5-flash` (recommended), `gemini-2.5-pro` (advanced)

## Limits

- Formats: Audio (WAV/MP3/AAC, 9.5h), Images (PNG/JPEG/WEBP), Video (MP4/MOV, 6h), PDF (1k pages)
- Size: 20MB inline, 2GB File API
- Transcription >15 min: split into chunks, transcribe each, combine

## Rules

- API key: `GEMINI_API_KEY` env var (rotate with `_2`, `_3` suffixes for high volume)
- Transcription output: markdown, include timestamps `[HH:MM:SS -> HH:MM:SS]`, metadata (duration, file, topics)
- Load `references/` for advanced: audio, vision, image-gen, video-gen, music
