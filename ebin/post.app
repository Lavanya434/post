{application, 'post', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['my_handler','post_app','post_sup']},
	{registered, [post_sup]},
	{applications, [kernel,stdlib,cowboy,epgsql]},
	{mod, {post_app, []}},
	{env, []}
]}.