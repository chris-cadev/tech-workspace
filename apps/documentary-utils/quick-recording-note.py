#!python
import datetime
import sys
import sounddevice as sd
import soundfile as sf
import numpy as np
import tempfile
import argparse
import pyaudio
import wave


def mean_mono_audio(recording):
    '''
    Checks if recording is stereo and convert to mono
    '''
    if recording.shape[1] != 2:
        return recording
    return np.mean(recording, axis=1)


def record_audio(duration, fs):
    recording = sd.rec(int(duration * fs), samplerate=fs, channels=2)
    sd.wait()  # Wait until recording is finished

    recording = mean_mono_audio(recording)

    # Reshape to 2D array with 1 channel
    recording = np.reshape(recording, (-1, 1))

    return recording


def save_audio_frames(fs, frames, filename):
    # Open the file in 'write-binary' mode
    with wave.open(filename, 'wb') as wf:
        wf.setnchannels(1)
        wf.setsampwidth(pyaudio.get_sample_size(pyaudio.paInt16))
        wf.setframerate(fs)
        wf.writeframes(b''.join(frames))


def generate_path(destination, prefix):
    if destination is None:
        with tempfile.NamedTemporaryFile(prefix=prefix, suffix='.wav', delete=False) as file:
            path = file.name
    elif len(prefix) > 0:
        path = f'{prefix}{destination}'
    else:
        path = destination

    return path


def save_audio(recording=None, frames=None, fs=None, destination=None):
    if recording is not None:
        sf.write(destination, recording, fs, format='wav')
    elif frames is not None:
        save_audio_frames(fs, frames, destination)
    else:
        raise ValueError("Either 'recording' or 'frames' must be provided.")

    return path


def infinite_record_audio(fs, frames=[]):
    FORMAT = pyaudio.paInt16
    CHUNK = 4096  # Use a larger buffer size
    audio = pyaudio.PyAudio()
    stream = audio.open(
        format=FORMAT,
        channels=1,
        rate=fs,
        input=True,
        frames_per_buffer=CHUNK)
    while True:
        try:
            data = stream.read(CHUNK)
            frames.append(data)
        except IOError as ex:
            if ex[1] != pyaudio.paInputOverflowed:
                raise ex
            print("Input overflow")
            continue


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Record audio from microphone.')
    parser.add_argument('-d', '--duration', type=float,
                        default=2.0, help='Duration of recording (in seconds)')
    parser.add_argument('-f', '--fs', type=int, default=44100,
                        help='Sample rate of recording (in Hz)')
    parser.add_argument('-o', '--output', type=str, default=None,
                        help='Path and filename to save the recording (default is a temporary file)')
    parser.add_argument('-i', '--infinite', action='store_true',
                        help='Record audio infinitely until stopped by Ctrl+C')

    args = parser.parse_args()

    frames = []
    recording = None
    if args.infinite:
        try:
            print("Recording...")
            sys.stdout.flush()
            infinite_record_audio(args.fs, frames)
        except (KeyboardInterrupt):
            print("Recording stopped.")
            sys.stdout.flush()
    else:
        print("Recording audio for", args.duration, "seconds...")
        sys.stdout.flush()
        recording = record_audio(args.duration, args.fs)

    now = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
    path = generate_path(args.output, prefix=f'{now}_')
    path = save_audio(recording=recording, frames=frames,
                      fs=args.fs, destination=path)

    sys.stdout.write(path)
