
## How to run

```sh
dune build
dune exec Cobb_PBT -- eval2
dune exec Cobb_PBT -- eval3
```

Visualize Results

```sh
make results
```

### Creating the Opam switch

```sh
opam switch create ./ --deps-only
```

### QCheck

Until the patch is release, we use a fork with a patch for QCheck

```sh
pwd
> ~/Cobb_PBT
git clone
```

### Luck experiment

Use `ghcup` for installing cabal and the specific ghc version.

```sh
python scripts/run_luck.py
```

### Run other enumeration evals

```sh
opam exec -- dune exec enumeration
```
