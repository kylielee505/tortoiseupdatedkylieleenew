import os
import sys
import uvicorn
from fastapi import FastAPI
import gradio as gr
from utils import setup_args, load_tts, setup_gradio

# Set up environment variables
os.environ.setdefault('TORTOISE_MODELS_DIR', os.path.realpath(os.path.join(os.getcwd(), './models/tortoise/')))
os.environ.setdefault('TRANSFORMERS_CACHE', os.path.realpath(os.path.join(os.getcwd(), './models/transformers/')))
os.environ['PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION'] = 'python'

if __name__ == "__main__":
    # Ensure to reset sys.argv to prevent issues with Gradio
    sys.argv = [sys.argv[0]]
    args = setup_args()

    # Check if listen_path is set
    if args.listen_path is not None and args.listen_path != "/":
        # Run FastAPI server with uvicorn
        uvicorn.run("main:app", host=args.listen_host, port=args.listen_port if args.listen_port is not None else 8000)
    else:
        # Launch Gradio UI
        webui = setup_gradio()
        webui.launch(share=args.share, prevent_thread_lock=True, show_error=True, server_name=args.listen_host, server_port=args.listen_port)
        
        # Load TTS model if not deferred
        if not args.defer_tts_load:
            tts = load_tts()
        
        # Block the thread for Gradio
        webui.block_thread()

# FastAPI application setup
app = FastAPI()

# Add Gradio UI to FastAPI app if listen_path is not root
if args.listen_path is not None and args.listen_path != "/":
    webui = setup_gradio()
    app = gr.mount_gradio_app(app, webui, path=args.listen_path)

# Load TTS model if not deferred
if not args.defer_tts_load:
    tts = load_tts()
