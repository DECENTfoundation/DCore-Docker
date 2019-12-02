Name: DCore
URL: https://decent.ch/dcore
Version: %{dcore_version}
Release: 1%{?dist}
License: GPLv3
Summary: Fast, powerful and cost-efficient blockchain
Source0: https://github.com/DECENTfoundation/DECENT-Network/archive/%{version}.tar.gz
Requires: openssl-libs >= 1.1, cryptopp >= 6.1, readline >= 7.0, ncurses-libs >= 6.1, libcurl, libpbc, gmp, zlib

%{?systemd_requires}
BuildRequires: systemd, json-devel, boost-devel >= 1.65.1

%description
DCore is the blockchain you can easily build on. As the world’s first blockchain
designed for digital content, media and entertainment, it provides user-friendly
software development kits (SDKs) that empower developers and businesses to build
decentralized applications for real-world use cases. DCore is packed-full of
customizable features making it the ideal blockchain for any size project.

%if "%{build_type}" == "RelWithDebInfo" || "%{build_type}" == "Debug"
%{debug_package}
%endif

%prep
git clone --single-branch --branch %{git_revision} https://github.com/DECENTfoundation/DECENT-Network.git
cd DECENT-Network
git submodule update --init --recursive

%build
cd DECENT-Network
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=%{build_type} -DCMAKE_INSTALL_PREFIX=%{buildroot}%{_usr} .
make -j$(nproc)

%install
cd DECENT-Network
make -j$(nproc) install
mkdir -p %{buildroot}%{_unitdir}
cp %{_builddir}/DECENT-Network/%{name}.service %{buildroot}%{_unitdir}

%clean
rm -rf DECENT-Network *.list
rm -rf %{buildroot}

%files
%{_bindir}/cli_wallet
%{_bindir}/decentd
%{_unitdir}/%{name}.service

%post
%systemd_post %{name}.service
if [ $1 -eq 1 ] && [ -x %{_bindir}/systemctl ]; then
    %{_bindir}/systemctl enable %{name} >/dev/null || :
fi

%preun
%systemd_preun %{name}.service

%postun
%systemd_postun_with_restart %{name}.service

%changelog
