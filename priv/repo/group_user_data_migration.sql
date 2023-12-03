INSERT INTO public.gifting_group_users
(id, display_name, is_admin, user_id, group_id, manager_id, inserted_at, updated_at)
select nextval('gifting_group_users_id_seq'), name, is_admin, id, 1, (select manager_id from user_managers um where um.user_id = u.id), now(), now() from users u;
