Name: DCore-python3
URL: https://decent.ch
Version: %{dcore_version}
Release: 1%{?dist}
License: GPLv3
Summary: Fast, powerful and cost-efficient blockchain
Source0: https://github.com/decent-dcore/DCore-Python/archive/%{version}.tar.gz
Requires: openssl-libs, cryptopp, readline, ncurses-libs, libcurl, libpbc, gmp, zlib, boost, boost-python3
BuildRequires: openssl-devel, cryptopp-devel, readline-devel, ncurses-devel, libcurl-devel, libpbc-devel, gmp-devel, zlib-devel, json-devel, python3-devel, boost-python3-devel

%description
DCore is the blockchain you can easily build on. As the world’s first blockchain
designed for digital content, media and entertainment, it provides user-friendly
software development kits (SDKs) that empower developers and businesses to build
decentralized applications for real-world use cases. DCore is packed-full of
customizable features making it the ideal blockchain for any size project.

%prep
git clone --single-branch --branch %{git_revision} https://github.com/decent-dcore/DCore-Python.git
cd DCore-Python
git submodule update --init --recursive

%build
cd DCore-Python
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=%{build_type} -DCMAKE_INSTALL_PREFIX=%{buildroot} -DPYTHON_VERSION=%{boost_python_version} .
make -j$(nproc)

%install
cd DCore-Python
make -j$(nproc) install
for f in %{buildroot}%{python3_sitearch}/*.so; do
    strip $f
done

%clean
rm -rf DCore-Python
rm -rf %{buildroot}

%files
%{python3_sitearch}/dcore.so
%{python3_sitelib}/DCore/

%changelog
