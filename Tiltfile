
print("""
-----------------------------------------------------------------
✨ APIs over DATA
-----------------------------------------------------------------
""".strip())
print('ℹ️ Open {tiltfile_path} in your favorite editor to get started...'.format(
    tiltfile_path=config.main_path))

docker_build('hasura-liquibase-migrations', context='./hasura/liquibase')

k8s_yaml(['k8s/hasura.yaml', 'k8s/postgres.yaml'])

# TO BE COMPLETED: use tilt to forward hasura's HTTP port.

# TO BE COMPLETED: use tilt to forward psql's port.
