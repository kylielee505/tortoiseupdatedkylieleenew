import os
import argparse
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)

# Set up environment variables
if 'TORTOISE_MODELS_DIR' not in os.environ:
    os.environ['TORTOISE_MODELS_DIR'] = os.path.realpath(os.path.join(os.getcwd(), './models/tortoise/'))

if 'TRANSFORMERS_CACHE' not in os.environ:
    os.environ['TRANSFORMERS_CACHE'] = os.path.realpath(os.path.join(os.getcwd(), './models/transformers/'))

os.environ['PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION'] = 'python'

from utils import *

if __name__ == "__main__":
    args = setup_args(cli=True)

    default_arguments = import_generate_settings()
    parser = argparse.ArgumentParser(allow_abbrev=False)
    parser.add_argument("--text", default=default_arguments['text'], help="Text to convert to speech.")
    parser.add_argument("--delimiter", default=default_arguments['delimiter'], help="Delimiter for splitting text.")
    parser.add_argument("--emotion", default=default_arguments['emotion'], help="Emotion tone for the voice.")
    parser.add_argument("--prompt", default=default_arguments['prompt'], help="Prompt for the TTS model.")
    parser.add_argument("--voice", default=default_arguments['voice'], help="Voice model to use.")
    parser.add_argument("--mic_audio", default=default_arguments['mic_audio'], help="Audio input from the microphone.")
    parser.add_argument("--voice_latents_chunks", default=default_arguments['voice_latents_chunks'], help="Chunks of voice latents.")
    parser.add_argument("--candidates", default=default_arguments['candidates'], help="Candidates for voice selection.")
    parser.add_argument("--seed", type=int, default=default_arguments['seed'], help="Random seed for generation.")
    parser.add_argument("--num_autoregressive_samples", type=int, default=default_arguments['num_autoregressive_samples'], help="Number of autoregressive samples.")
    parser.add_argument("--diffusion_iterations", type=int, default=default_arguments['diffusion_iterations'], help="Number of diffusion iterations.")
    parser.add_argument("--temperature", type=float, default=default_arguments['temperature'], help="Sampling temperature.")
    parser.add_argument("--diffusion_sampler", default=default_arguments['diffusion_sampler'], help="Diffusion sampler type.")
    parser.add_argument("--breathing_room", type=float, default=default_arguments['breathing_room'], help="Breathing room parameter.")
    parser.add_argument("--cvvp_weight", type=float, default=default_arguments['cvvp_weight'], help="CVVP weight parameter.")
    parser.add_argument("--top_p", type=float, default=default_arguments['top_p'], help="Top-p sampling parameter.")
    parser.add_argument("--diffusion_temperature", type=float, default=default_arguments['diffusion_temperature'], help="Diffusion temperature.")
    parser.add_argument("--length_penalty", type=float, default=default_arguments['length_penalty'], help="Length penalty for generation.")
    parser.add_argument("--repetition_penalty", type=float, default=default_arguments['repetition_penalty'], help="Repetition penalty for generation.")
    parser.add_argument("--cond_free_k", type=float, default=default_arguments['cond_free_k'], help="Conditional free K parameter.")

    args, unknown = parser.parse_known_args()
    
    # Validate required arguments
    if not args.text:
        logging.error("The 'text' argument is required. Please provide text to convert to speech.")
        exit(1)

    # Prepare arguments for TTS generation
    kwargs = {
        'text': args.text,
        'delimiter': args.delimiter,
        'emotion': args.emotion,
        'prompt': args.prompt,
        'voice': args.voice,
        'mic_audio': args.mic_audio,
        'voice_latents_chunks': args.voice_latents_chunks,
        'candidates': args.candidates,
        'seed': args.seed,
        'num_autoregressive_samples': args.num_autoregressive_samples,
        'diffusion_iterations': args.diffusion_iterations,
        'temperature': args.temperature,
        'diffusion_sampler': args.diffusion_sampler,
        'breathing_room': args.breathing_room,
        'cvvp_weight': args.cvvp_weight,
        'top_p': args.top_p,
        'diffusion_temperature': args.diffusion_temperature,
        'length_penalty': args.length_penalty,
        'repetition_penalty': args.repetition_penalty,
        'cond_free_k': args.cond_free_k,
        'experimentals': default_arguments['experimentals'],
    }

    # Load TTS and generate audio
    try:
        tts = load_tts()
        generate(**kwargs)
    except Exception as e:
        logging.error(f"Error during TTS generation: {e}")
        exit(1)
