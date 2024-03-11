# dot_erd

Creates a graphviz dot file of your schema from a postgres dump

Example:
```
  pg_dump --schema_only myapp_dev | dot_erd | dot -Tpng > myapp_erd.png
```
