#
# Cookbook Name:: change-shell
# Recipe:: default
#
# Copyright 2015, Marcin Nowicki
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#


[ node[:change_shell] ].flatten.each do |change_shell_user|
  user = change_shell_user[:username]
  shell = change_shell_user[:shell]

  if node[:platform] == 'mac_os_x'
    shell_before = `sudo dscl . read /users/#{user} UserShell | cut -b12-`.strip

    execute "sudo dscl . change /users/#{user} UserShell #{shell_before} #{shell}" do
      not_if { shell_before == shell }
    end
  else
    execute "sudo chsh -s #{shell} #{user}"
  end
end
