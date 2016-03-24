Promise = require('bluebird')
jwt = require('jsonwebtoken')

###
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! NOTICE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

The provided certificate should be used for DEVELOPMENT ONLY! Provide custom
certificate for production use

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
###

key = if process.env.SIGN_KEY then process.env.SIGN_KEY else """
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAkx7kF4GRfjxfCYNWnQHNzoUx9lqEAk2r13VU21/EAdfZviIc
CkIFDYufqqi6wjxEf2McEd7UmiaVfzVTnF3z1uhNALtM5SZtN4blrtf3NVM0EB//
pHhTA4EZTWvz45AromPEg8J3kK+U6d+sfq7pJUNhYyd5DF/53Tpl4RTucSeEmqtZ
j4T67FbVdodO9UP7ShXvj+HfotqxzttVFdM0suBqdrqycGHa6CoPjmJmqwjcvhHO
K94SlRPAG90qLXG3KW6YwY70MWxG1lmaX+VFCmvW8hr6WoAEZ2sACF7QEvR3pRg8
GnMnherF6zTvMX1EEf8YesXmuSeSbpVOviuZ/wIDAQABAoIBACZ3vUwoJNLNFkx2
ev8yqY2GZjn0EPBJPtVnaHiz4ZxZxCVi5dII0SlpiKYm2C5Rc9ebIovJp+1miVBp
sSMBrfBTbU7zqneARK5wJz5AWfMnfkV5GG74xzvzVZpYz7yAxegADjIldv3t6xH7
2i6FrZCAvcYfXBdQQRUHX/wqbO5I8XTwP0g4Wtl27e7Y/mr4h9cTLMGIP9WO9Pak
m8CneFO4xBFuZ8jEHinIO6lmVTA0Iop3Dydac34RNqqUbOETy9QB/pW1mn4Cy8Wa
lJCDko6Wl/Y428e1GDkPe+qavCyBlMJA1adYl50inuG6l8Y90AbvtqCqif7KJsLh
ZbDkZIECgYEAxAIRjhx6gJ2oyO0zvdImQ2Ulf8LKizPx2WrdnNYcpdCnbr9ODYVk
pyEstiiNO81NDMIbfCfbtmw/pUk5ULaaLjtyjCvHM8iSETdfHqj6b29zeTa9JITd
7xCeUKIV5D95OUVtpkCjpsQu5EcALuAYnjs4wjFY3AVdaCS0uXY0D3sCgYEAwCZR
yLGNa3XaownSDdnekpyWgS4P5kYNvNGP+DriZ8E4Y4qwZAiwnAZ5zU1sBAu6GSXj
SxuHk3yoSrECoe1j5B9Bzo+98spqrQKPAeIPXCV4Y0byezvsqVNWh88egwXzN5+k
fdNiCxGn3Mu+SjmlVLy5d0Rjj3aJTi/wtYQNNk0CgYBuPzOcmUwWF5eeHD0kIZXA
Bp5G9Et0bK01uzQXSR8n7OqgEh5W4JayoqhBdSGrZ1hVOsC23rxoKQ7Laxo/2dVy
96EAUodjCweNg3WPC0CBeVCb9zv/1HP4SYKim+hwT3thyTlZb7Yc0PAHGiByPT3b
kjfkklkGuEXHlA3K2z+BDQKBgC+51Np6b1vfm/ye9dOG5+eWiTNw03YotETP8GiB
h7apoW3oBsPx/JvkZ+B8eHXQy9pvNLN1FQmnDs3uhW7e3c7NjLTXsyBY8oIifo7D
LXl/vRU7jALb8X5lOrrk0PlOQwjv2BWAqXuCWSVYXd1l0BDqB07+Z5Q8pwIKmkkb
kYSJAoGAD4vOa578IEXRTdVeLBV5HQNqT+18eiowcklib1AdxJDggSibL5+XeNuY
bZSpTP0qk/6MbWJa+DwzYpMdUGh0UdJVPvBeFdEYQvuhdzxS/1gNgtR+DSpU/xZi
MpeKzBar+F0GgzBtw8RKdSHdEPd497A38qUn3W43Fh15i0V5r60=
-----END RSA PRIVATE KEY-----
"""

cert = if process.env.SIGN_CERT then process.env.SIGN_CERT else """
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkx7kF4GRfjxfCYNWnQHN
zoUx9lqEAk2r13VU21/EAdfZviIcCkIFDYufqqi6wjxEf2McEd7UmiaVfzVTnF3z
1uhNALtM5SZtN4blrtf3NVM0EB//pHhTA4EZTWvz45AromPEg8J3kK+U6d+sfq7p
JUNhYyd5DF/53Tpl4RTucSeEmqtZj4T67FbVdodO9UP7ShXvj+HfotqxzttVFdM0
suBqdrqycGHa6CoPjmJmqwjcvhHOK94SlRPAG90qLXG3KW6YwY70MWxG1lmaX+VF
CmvW8hr6WoAEZ2sACF7QEvR3pRg8GnMnherF6zTvMX1EEf8YesXmuSeSbpVOviuZ
/wIDAQAB
-----END PUBLIC KEY-----
"""

module.exports = require('./Jwt')(Promise, jwt, key, cert)
