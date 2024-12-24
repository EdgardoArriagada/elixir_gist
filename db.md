```text
mix phx.gen.context \
ContextFile SchemaName table_name \
row1 \
row2 \
```

```sh
mix phx.gen.context \
Gists Gist gists \
user_id:references:users \
name:string description:text \
markup_text:text
```

```sh
mix phx.gen.context \
Gists SavedGist saved_gists \
user_id:references:users \
gist_id:references:gists \
```

```sh
mix phx.gen.context \
Comments Comment comments \
user_id:references:user \
gist_id:references:gists \
markup_text:text \
```
