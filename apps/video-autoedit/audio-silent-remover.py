import os
import sys
import speech_recognition as sr
from pydub import AudioSegment

FILE_PATH = sys.argv[1]
FILE_DIR = os.path.dirname(FILE_PATH)
FILENAME = os.path.basename(FILE_PATH)
CHUNKS_DIR = f'{FILE_DIR}/chunks.{FILENAME}'
OUTPUT_FILENAME = f'{FILE_DIR}/non-talking.{FILE_PATH}'

# load audio file
sound = AudioSegment.from_file(FILE_PATH, format="wav")

# set parameters for splitting audio
min_silence_len = 500  # minimum silence length in milliseconds
silence_thresh = -60  # silence threshold in dBFS

# split audio into chunks based on silence
chunks = []
chunk_start = 0
chunk_end = 0
while chunk_end < len(sound):
    chunk = sound[chunk_end:chunk_end+min_silence_len]
    if chunk.dBFS < silence_thresh:
        if chunk_start != chunk_end:
            chunks.append((
                chunk_start,
                chunk_end,
                f'{CHUNKS_DIR}/({chunk_start}-{chunk_end}).{FILENAME}'
            ))
        chunk_start = chunk_end + min_silence_len
    chunk_end += min_silence_len
if chunk_start != chunk_end:
    chunks.append((
        chunk_start,
        chunk_end,
        f'{CHUNKS_DIR}/({chunk_start}-{chunk_end}).{FILENAME}'
    ))

# save chunks
for chunk in chunks:
    start, end, output_path = chunk
    chunk = sound[start:end]
    chunk.export(output_path, format="wav")


# extract talking parts
talking_parts = AudioSegment.empty()
for chunk in chunks:
    start, end, chunk_path = chunk
    r = sr.Recognizer()
    with sr.AudioFile(chunk_path) as chunk_audio:
        audio_listened = r.listen(chunk_audio)

    try:
        rec = r.recognize_google(audio_listened)
        talking_parts += sound[start:end]
    except sr.UnknownValueError:
        pass

# export talking parts to new audio file
talking_parts.export(OUTPUT_FILENAME, format="wav")
