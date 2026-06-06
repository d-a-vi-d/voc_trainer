--in der familie?
(EXISTS ( SELECT 1
   FROM family_member fm
  WHERE (fm.user_id = auth.uid()) AND (fm.family_id = TABELLE.family_id)))


--guardian in der familie?
  (EXISTS ( SELECT 1
   FROM (family_member fm
     JOIN profile p ON ((p.user_id = fm.user_id)))
  WHERE ((fm.user_id = auth.uid()) AND (fm.family_id = permission.family_id) AND (p.role = 'guardian'::family_role))))


--user selbst?
    user_id = auth.uid()

--participant?


--participants in den chats in denen man drinnen ist

--nur guardians 


--guardians in der familie und das Kind selbst
    ((EXISTS ( SELECT 1
    FROM (family_member fm
        JOIN profile p ON ((p.user_id = fm.user_id)))
    WHERE ((fm.user_id = auth.uid()) AND (fm.family_id = permission.family_id) AND (p.role = 'guardian'::family_role)))) 
    OR (child_id = auth.uid()))
