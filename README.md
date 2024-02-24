# dust_tm

A simple task manager demonstrating the capabilities and API of the
[`dust`][dust] package. `dust` is a local-first, persistable, reactive, and
synchronizable solution for state management and database.

[dust]: https://github.com/Parkour-Labs/dust.git

### Download

Clone the repository to your local disk with the `-r` flag, since we have not
yet released `dust` to [pub.dev][pdv], you will have to install the package
via git submodules:

```sh
git clone -r https://github.com/Parkour-Labs/dust_tm.git
```

If, when you cloned, you forgot to add the `-r` flag, then you can cd into the
`dust_tm` project root directory, and run the following command:

```sh
git submodule update --init --recursive
```

[pdv]: https://pub.dev/

### Installation

Please check out that you have `cargo` installed on your devices, as well as
the [compilation targets][cpt] correctly installed.

[cpt]: https://www.parkourlabs.io/docs/qs/1-installation/#step-2-add-targets

### Run

In your terminal, type:

```sh
flutter run
```

And (theoretically) a simple todo-list app would show up!

### Demo

![demo](assets/demo.gif)
