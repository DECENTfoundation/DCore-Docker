Name: DCore-GUI
URL: https://decent.ch/dcore
Version: %{dcore_version}
Release: 1%{?dist}
License: GPLv3
Summary: Fast, powerful and cost-efficient blockchain
Source0: https://github.com/DECENTfoundation/DECENT-Network/archive/%{version}.tar.gz
Requires: qt5-qtbase >= 5.11, openssl-libs >= 1.1, cryptopp >= 6.1, readline >= 7.0, ncurses-libs >= 6.1, libcurl, libpbc, gmp, zlib
BuildRequires: qt5-qtbase-devel >= 5.11, qt5-linguist >= 5.11, json-devel, boost-devel >= 1.65.1

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
git clone --single-branch --branch %{git_revision} git@github.com:DECENTfoundation/DECENT-GUI.git
cd DECENT-GUI
git submodule update --init --recursive

%build
cd DECENT-GUI
export PATH=/root/cmake/bin:$PATH
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=%{build_type} -DCMAKE_INSTALL_PREFIX=%{buildroot}%{_usr} .
make -j$(nproc)

%install
cd DECENT-GUI *.list
make -j$(nproc) install

%clean
rm -rf DECENT-GUI
rm -rf %{buildroot}

%files
%{_bindir}/DECENT

%changelog
