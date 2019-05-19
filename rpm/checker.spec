Name:           checker
Version:        1.0
Release:        1%{?dist}
Summary:	Created by Parkhomets, Kondratiev, Maximova, Sidorova
Group:		service
License:	MIT
URL:		http://centos.gremlinlab.com/gremlin_repo/checker.rpm
Source0:	%{name}.tar.gz
BuildArch:	noarch

%description
Service for permission checking

%prep
%setup -q -n %{name}

%install
mkdir -p %{buildroot}/opt/checker/
mkdir -p %{buildroot}/etc/systemd/system/
mkdir -p %{buildroot}/usr/share/man/man7/
install -m 755 checker.sh %{buildroot}/opt/checker/
install -m 644 checker.conf %{buildroot}/opt/checker/
install -m 644 checker.service %{buildroot}/etc/systemd/system/
install -m 644 checker.gz %{buildroot}/usr/share/man/man7/

%files
/etc/systemd/system/checker.service
/opt/checker/*
/usr/share/man/man7/checker.gz

%changelog
* Sun May 19 2019 Parkhomets
- Added /opt/checker/
