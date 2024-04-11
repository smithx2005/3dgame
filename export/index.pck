GDPC                �                                                                         T   res://.godot/exported/133200997/export-14584830dbc22d3f76a596eed5f4948e-node_3d.scn P      �      Sa��w�z�0D�D�    ,   res://.godot/global_script_class_cache.cfg  �:             ��Р�8���8~$}P�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex@      �      �̛�*$q�*�́        res://.godot/uid_cache.bin  `>      <       +3��S^��m�^4�h       res://Camera3D.gd           '
      ��Iq{���&Y��f       res://CharacterBody3D.gd0
      	      ���^�����v�n�5       res://InteractableCube.gd   �            "lf��5�;�x����>>       res://MeshInstance3D.gd        K      ��7R���<�?�F}       res://Rotating Cube.gd  �8      �      �ۑb����{ϰ��       res://Target.gd @7      L      �|a�2m����?���       res://Target2.gd�5      ^      ՙ�$�VDF�8�<|�       res://icon.svg  �:      �      C��=U���^Qu��U3       res://icon.svg.import          �       �[�O���.��E����       res://node_3d.tscn.remap:      d       �k�	���c{oo�       res://project.binary�>      �      �:ɿV�H���xHBW�            extends Camera3D

var sensitivity = 0.3
var speed = 5.0
var rot_x = 0.0
var rot_y = 0.0

var interactable_cubes = []
var dragging = false
var drag_distance = 0.0
var throw_strength = 40.0
var dragged_cube = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	interactable_cubes = [
		get_node("/root/Node3D/InteractableCube"),
		get_node("/root/Node3D/InteractableCube2")
	]
	
	for cube in interactable_cubes:
		if cube:
			print("Success finding cube: ", cube.name)

func _input(event):
	if event is InputEventMouseMotion:
		rot_x -= event.relative.y * sensitivity
		rot_y -= event.relative.x * sensitivity
		rot_x = clamp(rot_x, -90, 90) #make sure the camera can't flip
		rotation_degrees.x = rot_x
		rotation_degrees.y = rot_y
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if not dragging:
				# Cast a ray from the camera to check if it hits any interactable cube
				var from = project_ray_origin(event.position)
				var to = from + project_ray_normal(event.position) * 1000
				var space_state = get_world_3d().direct_space_state
				var ray_query = PhysicsRayQueryParameters3D.new()
				ray_query.from = from
				ray_query.to = to
				var result = space_state.intersect_ray(ray_query)
				
				if result:
					for cube in interactable_cubes:
						if result.collider == cube:
							dragging = true
							dragged_cube = cube
							drag_distance = global_transform.origin.distance_to(cube.global_transform.origin)
							cube.freeze = true # Disable physics simulation
							break
		
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if dragging and dragged_cube:
				var throw_direction = -global_transform.basis.z
				dragged_cube.freeze = false # Re-enable physics simulation
				dragged_cube.apply_impulse(throw_direction * throw_strength, Vector3.ZERO)
				dragging = false
				dragged_cube = null

func _process(delta):
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	#normalize to prevent faster diagonal movement
	direction = direction.normalized() * speed
	global_transform.origin += direction * delta
	
	if dragging and dragged_cube:
		var drag_position = global_transform.origin + (-global_transform.basis.z * drag_distance)
		dragged_cube.global_transform.origin = drag_position
         extends CharacterBody3D

var gravity = -9.8  # Adjust the gravity value as needed
var speed = 5.0  # Adjust the movement speed as needed

func _physics_process(delta):
	# Apply gravity
	velocity.y += gravity * delta
	
	# Get the input direction
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	# Calculate the movement velocity
	var movement_velocity = input_dir * speed
	movement_velocity.y = velocity.y
	
	# Move the character
	velocity = movement_velocity
	move_and_slide()
       GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�$�n윦���z�x����դ�<����q����F��Z��?&,
ScI_L �;����In#Y��0�p~��Z��m[��N����R,��#"� )���d��mG�������ڶ�$�ʹ���۶�=���mϬm۶mc�9��z��T��7�m+�}�����v��ح�m�m������$$P�����එ#���=�]��SnA�VhE��*JG�
&����^x��&�+���2ε�L2�@��		��S�2A�/E���d"?���Dh�+Z�@:�Gk�FbWd�\�C�Ӷg�g�k��Vo��<c{��4�;M�,5��ٜ2�Ζ�yO�S����qZ0��s���r?I��ѷE{�4�Ζ�i� xK�U��F�Z�y�SL�)���旵�V[�-�1Z�-�1���z�Q�>�tH�0��:[RGň6�=KVv�X�6�L;�N\���J���/0u���_��U��]���ǫ)�9��������!�&�?W�VfY�2���༏��2kSi����1!��z+�F�j=�R�O�{�
ۇ�P-�������\����y;�[ ���lm�F2K�ޱ|��S��d)é�r�BTZ)e�� ��֩A�2�����X�X'�e1߬���p��-�-f�E�ˊU	^�����T�ZT�m�*a|	׫�:V���G�r+�/�T��@U�N׼�h�+	*�*sN1e�,e���nbJL<����"g=O��AL�WO!��߈Q���,ɉ'���lzJ���Q����t��9�F���A��g�B-����G�f|��x��5�'+��O��y��������F��2�����R�q�):VtI���/ʎ�UfěĲr'�g�g����5�t�ۛ�F���S�j1p�)�JD̻�ZR���Pq�r/jt�/sO�C�u����i�y�K�(Q��7őA�2���R�ͥ+lgzJ~��,eA��.���k�eQ�,l'Ɨ�2�,eaS��S�ԟe)��x��ood�d)����h��ZZ��`z�պ��;�Cr�rpi&��՜�Pf��+���:w��b�DUeZ��ڡ��iA>IN>���܋�b�O<�A���)�R�4��8+��k�Jpey��.���7ryc�!��M�a���v_��/�����'��t5`=��~	`�����p\�u����*>:|ٻ@�G�����wƝ�����K5�NZal������LH�]I'�^���+@q(�q2q+�g�}�o�����S߈:�R�݉C������?�1�.��
�ڈL�Fb%ħA ����Q���2�͍J]_�� A��Fb�����ݏ�4o��'2��F�  ڹ���W�L |����YK5�-�E�n�K�|�ɭvD=��p!V3gS��`�p|r�l	F�4�1{�V'&����|pj� ߫'ş�pdT�7`&�
�1g�����@D�˅ �x?)~83+	p �3W�w��j"�� '�J��CM�+ �Ĝ��"���4� ����nΟ	�0C���q'�&5.��z@�S1l5Z��]�~L�L"�"�VS��8w.����H�B|���K(�}
r%Vk$f�����8�ڹ���R�dϝx/@�_�k'�8���E���r��D���K�z3�^���Vw��ZEl%~�Vc���R� �Xk[�3��B��Ğ�Y��A`_��fa��D{������ @ ��dg�������Mƚ�R�`���s����>x=�����	`��s���H���/ū�R�U�g�r���/����n�;�SSup`�S��6��u���⟦;Z�AN3�|�oh�9f�Pg�����^��g�t����x��)Oq�Q�My55jF����t9����,�z�Z�����2��#�)���"�u���}'�*�>�����ǯ[����82һ�n���0�<v�ݑa}.+n��'����W:4TY�����P�ר���Cȫۿ�Ϗ��?����Ӣ�K�|y�@suyo�<�����{��x}~�����~�AN]�q�9ޝ�GG�����[�L}~�`�f%4�R!1�no���������v!�G����Qw��m���"F!9�vٿü�|j�����*��{Ew[Á��������u.+�<���awͮ�ӓ�Q �:�Vd�5*��p�ioaE��,�LjP��	a�/�˰!{g:���3`=`]�2��y`�"��N�N�p���� ��3�Z��䏔��9"�ʞ l�zP�G�ߙj��V�>���n�/��׷�G��[���\��T��Ͷh���ag?1��O��6{s{����!�1�Y�����91Qry��=����y=�ٮh;�����[�tDV5�chȃ��v�G ��T/'XX���~Q�7��+[�e��Ti@j��)��9��J�hJV�#�jk�A�1�^6���=<ԧg�B�*o�߯.��/�>W[M���I�o?V���s��|yu�xt��]�].��Yyx�w���`��C���pH��tu�w�J��#Ef�Y݆v�f5�e��8��=�٢�e��W��M9J�u�}]釧7k���:�o�����Ç����ս�r3W���7k���e�������ϛk��Ϳ�_��lu�۹�g�w��~�ߗ�/��ݩ�-�->�I�͒���A�	���ߥζ,�}�3�UbY?�Ӓ�7q�Db����>~8�]
� ^n׹�[�o���Z-�ǫ�N;U���E4=eȢ�vk��Z�Y�j���k�j1�/eȢK��J�9|�,UX65]W����lQ-�"`�C�.~8ek�{Xy���d��<��Gf�ō�E�Ӗ�T� �g��Y�*��.͊e��"�]�d������h��ڠ����c�qV�ǷN��6�z���kD�6�L;�N\���Y�����
�O�ʨ1*]a�SN�=	fH�JN�9%'�S<C:��:`�s��~��jKEU�#i����$�K�TQD���G0H�=�� �d�-Q�H�4�5��L�r?����}��B+��,Q�yO�H�jD�4d�����0*�]�	~�ӎ�.�"����%
��d$"5zxA:�U��H���H%jس{���kW��)�	8J��v�}�rK�F�@�t)FXu����G'.X�8�KH;���[             [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://bqku1qtxnikuv"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
                extends RigidBody3D

func _ready():
	# Connect the body_entered signal to the _on_body_entered function
	pass

func _on_body_entered(body):
	# Print a message when the interactable cube collides with another body
	print("Interactable cube collided with: ", body)
         extends MeshInstance3D

var rotating = false
var rotation_speed = 2.0 # Rotation speed in degrees per frame

func _ready():
	pass # Replace with function body if needed

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		rotating = !rotating 

	if rotating:
		rotate_y(deg_to_rad(rotation_speed * delta * 60)) 
     RSRC                    PackedScene            ��������                                            �      ..    Rotating Cube    InteractableCube    MeshInstance3D    Target2    Target3    Target4    resource_local_to_scene    resource_name    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    left_to_right    size    subdivide_width    subdivide_height    subdivide_depth    script    custom_solver_bias    margin    render_priority 
   next_pass    transparency    blend_mode 
   cull_mode    depth_draw_mode    no_depth_test    shading_mode    diffuse_mode    specular_mode    disable_ambient_light    disable_fog    vertex_color_use_as_albedo    vertex_color_is_srgb    albedo_color    albedo_texture    albedo_texture_force_srgb    albedo_texture_msdf 	   metallic    metallic_specular    metallic_texture    metallic_texture_channel 
   roughness    roughness_texture    roughness_texture_channel    emission_enabled 	   emission    emission_energy_multiplier    emission_operator    emission_on_uv2    emission_texture    normal_enabled    normal_scale    normal_texture    rim_enabled    rim 	   rim_tint    rim_texture    clearcoat_enabled 
   clearcoat    clearcoat_roughness    clearcoat_texture    anisotropy_enabled    anisotropy    anisotropy_flowmap    ao_enabled    ao_light_affect    ao_texture 
   ao_on_uv2    ao_texture_channel    heightmap_enabled    heightmap_scale    heightmap_deep_parallax    heightmap_flip_tangent    heightmap_flip_binormal    heightmap_texture    heightmap_flip_texture    subsurf_scatter_enabled    subsurf_scatter_strength    subsurf_scatter_skin_mode    subsurf_scatter_texture &   subsurf_scatter_transmittance_enabled $   subsurf_scatter_transmittance_color &   subsurf_scatter_transmittance_texture $   subsurf_scatter_transmittance_depth $   subsurf_scatter_transmittance_boost    backlight_enabled 
   backlight    backlight_texture    refraction_enabled    refraction_scale    refraction_texture    refraction_texture_channel    detail_enabled    detail_mask    detail_blend_mode    detail_uv_layer    detail_albedo    detail_normal 
   uv1_scale    uv1_offset    uv1_triplanar    uv1_triplanar_sharpness    uv1_world_triplanar 
   uv2_scale    uv2_offset    uv2_triplanar    uv2_triplanar_sharpness    uv2_world_triplanar    texture_filter    texture_repeat    disable_receive_shadows    shadow_to_opacity    billboard_mode    billboard_keep_scale    grow    grow_amount    fixed_size    use_point_size    point_size    use_particle_trails    proximity_fade_enabled    proximity_fade_distance    msdf_pixel_range    msdf_outline_size    distance_fade_mode    distance_fade_min_distance    distance_fade_max_distance 	   _bundled       Script    res://MeshInstance3D.gd ��������   Script    res://Rotating Cube.gd ��������   Script    res://Camera3D.gd ��������   Script    res://Target.gd ��������   Script    res://Target2.gd ��������      local://PrismMesh_x533f #         local://BoxMesh_w3ug6 =         local://BoxShape3D_lkdlr U      !   local://StandardMaterial3D_c1j2l �         local://BoxMesh_lo0ii �         local://BoxShape3D_xivck �         local://BoxShape3D_u5sej          local://PackedScene_xdipy 5      
   PrismMesh             BoxMesh             BoxShape3D          ��?  �?㥫?         StandardMaterial3D    %        �?      �?  �?         BoxMesh             BoxShape3D          �L!A �='� A         BoxShape3D            �?
hX@��@         PackedScene    �      	         names "         Node3D    Rotating Triangle 
   transform    mesh 	   skeleton    script    MeshInstance3D    Rotating Cube    InteractableCube    RigidBody3D    CollisionShape3D    shape    surface_material_override/0    StaticBody3D 	   Camera3D 
   RayCast3D    target_position    InteractableCube2    Target    Target2    Target3    Target4    DirectionalLight3D    shadow_enabled    	   variants    #      gGz>            U�?            �]F>鲭�]�?>Z<?                                    ��>              �?            ��?�fn����?$B>                                       �?              �?              �? ��    �`�                                   sh"A            ��=            3�!A    ��                  �?              �?              �?�?6=q�� ��              �?              �?              �?���� �:?�@              �?            1�;�  ��      �?1�;��aP�}c �#\�         ��         �?              �?              �?8��?    ��ȿ     �?              �?              �?�?�A_{�@��            ��?            �I1@            t�U@    ��       C�K?            C�K?            C�K?    g��e�e�            �:>?    ]P+?      �?    ]P+�    �:>?��kAF�>�ov�                             M���Y<�mS?�P�>\?c��>��4�+�?� �������,�@��                    ҧ�>    7�h?      �?    7�h�    ҧ�>�/3A��AI��                    Z�(>�>,?�8�PQݾ"�4?Xp?o�b?��`>-��>���T�g@�Y��            node_count             nodes     %  ��������        ����                      ����                                              ����                                       	      ����               
   
   ����            	                    ����            
                           ����                     ����                          
   
   ����                                 ����                   	             ����                           	      ����                    
   
   ����      	                    ����                                 ����                                ����                          
   
   ����                                 ����                                ����                                
   
   ����                                 ����                          ����                                
   
   ����                                 ����                          ����                                 
   
   ����                                 ����      !      "             conn_count              conns               node_paths              editable_instances              version             RSRC        extends StaticBody3D

func _ready():
	pass

func _on_interactable_cube_body_entered(body):
	print("Body entered: ", body)
	body.global_transform.origin = Vector3.ZERO

func _on_interactable_cube_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print("Body shape entered: ", body)
	body.global_transform.origin = Vector3.ZERO
  extends StaticBody3D

func _ready():
	pass

func _on_body_entered(body):
	print("Body entered: ", body)
	body.global_transform.origin = Vector3.ZERO

func _on_interactable_cube_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print("Body shape entered: ", body)
	body.global_transform.origin = Vector3.ZERO
    extends MeshInstance3D

var rotating = false
var rotation_speed = 10.0 # Rotation speed in degrees per frame

func _ready():
	pass # Replace with function body if needed

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		rotating = !rotating 

	if rotating:
		rotate_y(deg_to_rad(rotation_speed * delta * 60)) 
		rotate_x(deg_to_rad(rotation_speed * delta * 60))
[remap]

path="res://.godot/exported/133200997/export-14584830dbc22d3f76a596eed5f4948e-node_3d.scn"
            list=Array[Dictionary]([])
     <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
             �Ƚ���1   res://icon.svgqB��P<R   res://node_3d.tscn    ECFG      application/config/name         3didk      application/run/main_scene         res://node_3d.tscn     application/config/features(   "         4.2    GL Compatibility       application/config/icon         res://icon.svg     input/move_forward�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device         	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   W   	   key_label             unicode           echo          script         input/move_backward�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   S   	   key_label             unicode    s      echo          script         input/move_left�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   A   	   key_label             unicode    a      echo          script         input/move_right�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   D   	   key_label             unicode    d      echo          script         input/move_up�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script         input/move_down�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script         input/interact�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask          position     �B  0A   global_position      �B  PB   factor       �?   button_index         canceled          pressed          double_click          script      #   rendering/renderer/rendering_method         gl_compatibility*   rendering/renderer/rendering_method.mobile         gl_compatibility2   rendering/environment/defaults/default_clear_color      ���>��$>���>  �?        