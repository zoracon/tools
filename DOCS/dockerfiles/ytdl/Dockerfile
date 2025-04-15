# Use a lightweight Python base image
FROM python:3-slim

# Install ffmpeg (required for audio extraction/conversion)
# Also update package lists and clean up afterward
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install/Update yt-dlp using pip
RUN pip install --no-cache-dir -U yt-dlp

# Set a working directory inside the container for downloads
WORKDIR /downloads

# Set yt-dlp as the entrypoint WITH default audio extraction flags.
# -f bestaudio/best: Select the best quality audio-only format. Fallback to best overall if no separate audio.
# -x: Extract audio.
# --audio-format mp3: Convert the extracted audio to mp3 format. Change if you prefer wav, m4a, ogg, etc.
# -o '/downloads/%(title)s.%(ext)s': Default output template inside the container's working directory.
ENTRYPOINT ["yt-dlp", "-f", "bestaudio/best", "-x", "--audio-format", "mp3", "-o", "/downloads/%(title)s.%(ext)s"]

# No CMD needed now, as the entrypoint has default actions.
