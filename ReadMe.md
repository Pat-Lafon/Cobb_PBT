
## How to run

```sh
dune build
export QCHECK_MSG_INTERVAL=2000.0 && dune exec Cobb_PBT -- eval2
export QCHECK_MSG_INTERVAL=2000.0 && dune exec Cobb_PBT -- eval3
```

We set a high message interval to avoid seeing a bunch of intermediate
output at every 0.1 seconds.

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

### Running the number of unique values eval

```sh
opam exec -- dune exec num_unique
```
