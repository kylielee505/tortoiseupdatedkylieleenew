import os
import sys
import argparse
import yaml
import datetime

from torch.distributed.run import main as torchrun
from dlas import train as tr
from dlas.utils import util, options as option

def train(config_path, launcher='none'):
    """Train the model using the provided configuration path."""
    opt = option.parse(config_path, is_train=True)

    # Handle multi-GPU training with PyTorch's launcher
    if launcher == 'none' and opt['gpus'] > 1:
        return torchrun([f"--nproc_per_node={opt['gpus']}", "./src/train.py", "--yaml", config_path, "--launcher=pytorch"])

    trainer = tr.Trainer()

    # Configure distributed training
    if launcher == 'none':
        opt['dist'] = False
        trainer.rank = -1
        if len(opt['gpu_ids']) == 1:
            torch.cuda.set_device(opt['gpu_ids'][0])
        print('Disabled distributed training.')
    else:
        opt['dist'] = True
        tr.init_dist('nccl', timeout=datetime.timedelta(seconds=5*60))
        trainer.world_size = torch.distributed.get_world_size()
        trainer.rank = torch.distributed.get_rank()
        torch.cuda.set_device(trainer.rank)

    # Initialize trainer and start training
    trainer.init(config_path, opt, launcher, '')
    trainer.do_training()

def main():
    """Main function to handle argument parsing and model training."""
    parser = argparse.ArgumentParser()
    parser.add_argument('--yaml', type=str, help='Path to training configuration file.', 
                        default='./training/voice/train.yml', nargs='+')
    parser.add_argument('--launcher', choices=['none', 'pytorch'], default='none', help='Job launcher')
    
    args = parser.parse_args()
    config_path = " ".join(args.yaml)  # Concatenate YAML paths

    # Load the configuration file
    with open(config_path, 'r') as file:
        opt_config = yaml.safe_load(file)

    # Override BitsAndBytes settings based on configuration
    if "bitsandbytes" in opt_config and not opt_config["bitsandbytes"]:
        os.environ['BITSANDBYTES_OVERRIDE_LINEAR'] = '0'
        os.environ['BITSANDBYTES_OVERRIDE_EMBEDDING'] = '0'
        os.environ['BITSANDBYTES_OVERRIDE_ADAM'] = '0'
        os.environ['BITSANDBYTES_OVERRIDE_ADAMW'] = '0'

    # Check for BitsAndBytes optimizations
    try:
        import torch_intermediary
        if torch_intermediary.OVERRIDE_ADAM:
            print("Using BitsAndBytes optimizations")
        else:
            print("NOT using BitsAndBytes optimizations")
    except ImportError as e:
        print("torch_intermediary could not be imported. Defaulting to standard optimizations.")

    # Start training
    train(config_path, args.launcher)

if __name__ == "__main__":
    main()
