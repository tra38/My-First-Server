== Security Flaw ==
It is possible to edit cookies on the client-side, and send the edited cookie over to the server, thereby manipulating the server to do what you want it to do.

My Solution - Encrypt the cookie using the gibberish gem, creating an JSON. Then, encode the JSON using Base64. Very haphazard approach, but this is why I'm not in security. You need to decrypt the resulting cookie as well.

Rails Solution - Encode the cookie using Base64, and send also a digest along with the cookie. When the user sends a cookie back to the server, determine the digest of that cookie. If the digest of the new cookie does NOT match the digest of the old cookie, the cookie has been tampered with. Reset the cookie entirely! This solution does NOT require encryption at all...the user can easily determine the cookie values easily but can't change them UNLESS they determine the secret_token that is being used to generate the digests in question.

However, starting in Rails 4, all cookies are encrypted by default. Decryption requires a "secret_key_base" as well.

Rails refer to the digest at the end of the cookie as being "signed". So not only must you decrypt a cookie to find out what it means, but you also must forge the signature as well.

My solution and Rails 4' solution both uses AES-256 encryption.

== Security Flaw #2 ==
XSS attacks can occur when you do not properly filter user input. If users are allowed to inject artibrary HTML into their websites, they can use it to do *bad* stuff. Such as steal people's cookies.

Ruby has a method ["CGI::escapeHTML"](http://ruby-doc.org/stdlib-2.0.0/libdoc/cgi/rdoc/CGI.html#method-c-escapeHTML) that can handle this specific issue, and I called it on every section where I expect user input. Rails is much easier in that HTML escaping occurs by default, and you have to intentionally opt-out of it by using the 'html_safe' method.


== Cookie Necessary To Steal Cookies ==
```javascript
//Source: http://stackoverflow.com/a/21125098
function getCookie(name) {
  match = document.cookie.match(new RegExp(name + '=([^;]+)'));
  if (match) return match[1];
}

console.log("Here is our stolen cookie...mwahaha")
console.log(getCookie("FirstServerCookie"));
```