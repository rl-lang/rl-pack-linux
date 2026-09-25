Name:           rl-lang
Version:        2.2.1
Release:        1%{?dist}
Summary:        Programming language with first-class VM and C transpiler

License:        MIT OR Apache-2.0
URL:            https://github.com/rl-lang/rl-lang
Source0:        %{url}/archive/v%{version}/%{name}-%{version}.tar.gz

BuildRequires:  cargo
BuildRequires:  rustc
BuildRequires:  pkg-config

%description
rl-lang is a modern programming language featuring a bytecode VM and
C transpilation. It includes a REPL, language server, and standard
library.

%prep
%autosetup -n %{name}-%{version}

%build
cargo build --release --all-features

%install
for bin in rl rlc rlt rlrepl rlsp rldocs rlm; do
  install -Dm755 "target/release/$bin" "%{buildroot}%{_bindir}/$bin"
done
install -Dm644 man/rl.1 %{buildroot}%{_mandir}/man1/rl.1
install -Dm644 man/rl.info %{buildroot}%{_infodir}/rl.info

%files
%license LICENSE-MIT.md LICENSE-APACHE.md
%doc README.md CHANGELOG.md
%{_bindir}/rl
%{_bindir}/rlc
%{_bindir}/rlt
%{_bindir}/rlrepl
%{_bindir}/rlsp
%{_bindir}/rldocs
%{_bindir}/rlm
%{_mandir}/man1/rl.1
%{_infodir}/rl.info

%changelog
* Thu Sep 25 2026 rl-lang maintainers <https://github.com/rl-lang/rl-lang> - 2.2.1-1
- Full binary set (rl, rlc, rlt, rlrepl, rlsp, rldocs, rlm)
* Mon Sep 09 2026 rl-lang maintainers <https://github.com/rl-lang/rl-lang> - 2.1.0-1
- Initial RPM package
