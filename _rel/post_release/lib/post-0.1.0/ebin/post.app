{application, 'post', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['my_handler','my_server','post_app','post_sup']},
	{registered, [post_sup]},
	{applications, [kernel,stdlib,cowboy,poolboy,epgsql]},
	{mod, {post_app, []}},
	{env, [
        {pools, [
            {pool1, [
                {size, 10},
                {max_overflow, 20}
			], [
                {hostname, "localhost"},
                {database, "postgres"},
                {username, "postgres"},
                {password, "postgres"}
            ]},
            {pool2, [
                {size, 5},
                {max_overflow, 10}
			], [
                {hostname, "localhost"},
                {database, "postgres"},
                {username, "postgres"},
                {password, "postgres"}
            ]}
        ]}
    ]}
]}.