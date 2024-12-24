```sh
mix phx.gen.context \
Gists Gist gists \
user_id:references:users \
name:string description:text \
markup_text:text
```
