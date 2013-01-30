#   Copyright 2012-2013 Barry Allard <barry.allard@gmail.com>
#   All rights reserved.
#
#   Redistribution and use in source and binary forms, with or without modification,
#   are permitted provided that the following conditions are met:
#
#     1. Redistributions of source code must retain the above copyright notice, this
#        list of conditions and the following disclaimer.
#
#     2. Redistributions in binary form must reproduce the above copyright notice,
#        this list of conditions and the following disclaimer in the documentation
#        and/or other materials provided with the distribution.
#
#     3. The names of its contributors may not be used to endorse or promote products
#        derived from this software without specific prior written permission.
#
#   THIS SOFTWARE  IS PROVIDED BY THE  COPYRIGHT HOLDERS AND  CONTRIBUTORS "AS IS" AND
#   ANY EXPRESS  OR IMPLIED  WARRANTIES,  INCLUDING, BUT  NOT LIMITED TO,  THE IMPLIED
#   WARRANTIES OF MERCHANTABILITY AND FITNESS  FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
#   IN NO EVENT SHALL THE  COPYRIGHT HOLDER OR  CONTRIBUTORS  BE LIABLE FOR ANY DIRECT,
#   INDIRECT,  INCIDENTAL,  SPECIAL, EXEMPLARY,  OR  CONSEQUENTIAL  DAMAGES (INCLUDING,
#   BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
#   OR  PROFITS;  OR  BUSINESS INTERRUPTION)  HOWEVER  CAUSED  AND  ON  ANY  THEORY OF
#   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#   OTHERWISE) ARISING IN ANY WAY OUT OF THE  USE OF THIS SOFTWARE, EVEN IF ADVISED OF
#   THE POSSIBILITY OF SUCH DAMAGE.

# Link to original gist https://gist.github.com/2040373

# Ask for a password from unix CLI,
# if it exists.

def ask_for_password(prompt = "Enter password: ")
  raise 'Could not ask for password because there is no interactive terminal (tty)' unless $stdin.tty?
  unless prompt.nil?
    $stderr.print prompt
    $stderr.flush
  end
  raise 'Could not disable echo to ask for password security' unless system 'stty -echo -icanon'
  password = $stdin.gets
  password.chomp! if password
  password
ensure
  raise 'Could not re-enable echo while securely asking for password' unless system 'stty echo icanon'
end
