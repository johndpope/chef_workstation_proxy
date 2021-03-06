#
# Cookbook Name:: blockchain_proxy
# Recipe:: default
#
# Copyright 2016, Gabriel
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
git '/home/big_earth_blockchain/blockchain_proxy' do
  repository 'https://github.com/bigearth/blockchain_proxy.git'
  revision 'master'
end

execute 'bundle install' do
  cwd '/home/big_earth_blockchain/blockchain_proxy'
end

execute 'unicorn' do
  cwd '/home/big_earth_blockchain/blockchain_proxy'
end
