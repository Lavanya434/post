{application, 'post', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['my_handler','my_server','post_app','post_sup']},
	{registered, [post_sup]},
	{applications, [kernel,stdlib,cowboy,poolboy,epgsql]},
	{mod, {post_app, []}},
	{env, []}
]}.