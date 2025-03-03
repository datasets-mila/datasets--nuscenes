from pathlib import Path
import os

import datasets


def load_dataset(path:str, *, cache_dir:str, **kwargs):
    builder_kwargs = {
        "path": path,
        "cache_dir": cache_dir,
        **{
            k:kwargs[k] for k in datasets.load_dataset_builder.__code__.co_varnames
            if k in kwargs
        }
    }
    builder_cache_dir = Path(datasets.load_dataset_builder(**builder_kwargs).cache_dir)
    builder_cache_dir.mkdir(parents=True, exist_ok=True)
    src_builder_cache_dir = datasets.config.HF_DATASETS_CACHE / builder_cache_dir.relative_to(cache_dir)
    for _f in src_builder_cache_dir.glob("**/*"):
        if _f.is_dir():
            continue
        _f = _f.relative_to(src_builder_cache_dir)
        (builder_cache_dir / _f).parent.mkdir(parents=True, exist_ok=True)
        try:
            if (builder_cache_dir / _f).readlink() == src_builder_cache_dir / _f:
                continue
            (builder_cache_dir / _f).unlink()
        except FileNotFoundError:
            pass
        (builder_cache_dir / _f).symlink_to(src_builder_cache_dir / _f)
    return datasets.load_dataset(path, cache_dir=cache_dir, **kwargs)
