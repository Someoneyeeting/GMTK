GDPC                0                                                                         P   res://.godot/exported/133200997/export-08bd25e3251a4adb1288a88c1d8cc503-fall.scn�      ?      ���d;G �`'4��    T   res://.godot/exported/133200997/export-362256a061aa8890e9a1e558b11e5ec3-node_2d.scn p       �      ,�"K�3�V/62�}�4    P   res://.godot/exported/133200997/export-4fe1464105c47ebb93ca2be69ccaeb47-tail.scn0-      �      Ť�c�!qj�ыZ7�    T   res://.godot/exported/133200997/export-65a124e7c268d791d04f413a6d11990a-spike.scn   (      |      ��w-g�a�n�G��    P   res://.godot/exported/133200997/export-c6126d1cbebe690335fabb9cc27c1427-head.scnp            �u�ݐ?̈́oF��#	    T   res://.godot/exported/133200997/export-cd8ca12872c88409033478bd9c5705a5-deadbody.scn        �      �}����A�)o~肰D    ,   res://.godot/global_script_class_cache.cfg  �4             ��Р�8���8~$}P�    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex�            ：Qt�E�cO���       res://.godot/uid_cache.bin  p8      �        �Hۣ��CG���       res://deadbody.tscn.remap   �1      e       ��v��n����l��`       res://fall.tscn.remap   `2      a       ͌$5m֍?���q��)�       res://head.gd          f      >���Z wn�����?�       res://head.tscn.remap   �2      a       �uQ��8#��?
�t}N>       res://icon.svg  �4      �      k����X3Y���f       res://icon.svg.import   �      �       �G�ip&�����5]�       res://node_2d.tscn.remap@3      d       s�OR��0*�FC       res://project.binary@9      �      y1Y.} 5u/��8�       res://spike.gd   (             �����p0|<UA/��4�       res://spike.tscn.remap  �3      b       �T��f��Yp6mJ
�H       res://tail.gd   �,      �       �X�yU��1��w���%       res://tail.tscn.remap    4      a       6��������X��Ԁ                RSRC                    PackedScene            ��������                                                  ..    resource_local_to_scene    resource_name 	   _bundled    script       PackedScene    res://fall.tscn y�K=S      local://PackedScene_fng84          PackedScene          	         names "      	   deadbody    CharacterBody2D    fall    target    	   variants                                 node_count             nodes        ��������       ����                ���            @             conn_count              conns               node_paths              editable_instances              version             RSRC             RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    script/source 	   _bundled    script           local://GDScript_hcgoq          local://PackedScene_mcbw7 �      	   GDScript             fall       �   extends Node


@export var target : CharacterBody2D

func _physics_process(delta: float) -> void:
	target.velocity.y = 10 / delta
	target.move_and_slide()
    PackedScene          	         names "         fall    script    Node    	   variants                       node_count             nodes     	   ��������       ����                    conn_count              conns               node_paths              editable_instances              version             RSRC extends CharacterBody2D

@export var length = 4


var grid_scale = Vector2(40,40)

const TAIL = preload("res://tail.tscn")
const BODY = preload("res://deadbody.tscn")
var cols := []
var poses = []
var off := Vector2.ZERO
var frameedit = false

func add_tail():
	var tail = TAIL.instantiate()
	tail.ind = cols.size()
	cols.append(tail)
	add_child(tail)
	tail.modulate = lerp(Color.WHITE,Color.BLACK,float(cols.size()) / length)
	tail.cut.connect(cut)

func _ready() -> void:
	
	for i in length:
		add_tail()
	
	$rayspos.reparent(cols[0])

func cut(ind):
	if(ind == 0 or ind >= cols.size()):
		return
	cols[ind].queue_free()
	length = ind
	if(ind != cols.size() - 1):
		var body = BODY.instantiate()
		for i in range(ind + 1,cols.size()):
			cols[i].reparent(body)
		get_parent().add_child.call_deferred(body)

func _input(event: InputEvent) -> void:
	var dir = Vector2.ZERO
	if(frameedit):
		return
	if(not is_on_floor()):
		return
	if(event.is_action_pressed("right") and not %right.is_colliding()):
		dir.x = grid_scale.x
	elif(event.is_action_pressed("left") and not %left.is_colliding()):
		dir.x = -grid_scale.x
	elif(event.is_action_pressed("up") and not %up.is_colliding()):
		dir.y = -grid_scale.y
	elif(event.is_action_pressed("down") and not %down.is_colliding()):
		dir.y = grid_scale.y
	else:
		return
	
	frameedit = true
	off += dir
	poses.insert(0,dir)
	#$CollisionShape2D.position = off
	while(poses.size() > cols.size()):
		poses.pop_back()
	
	for i in range(poses.size()):
		cols[i].position += poses[i]
	


func _physics_process(delta: float) -> void:
	$Node2D.position = cols[0].position
	velocity.y = 10 / delta
	move_and_slide()
	
	while(cols.size() > length):
		cols.pop_back()
	while(cols.size() < length):
		var tail = TAIL.instantiate()
		tail.position = cols[-1].position
		cols.append(tail)
		add_child(tail)
	frameedit = false
	#print($CharacterBody2D.is_on_floor())
          RSRC                    PackedScene            ��������                                                  ..    Node2D    resource_local_to_scene    resource_name 	   _bundled    script       Script    res://head.gd ��������      local://PackedScene_doqt6          PackedScene          	         names "         head    script    length    CharacterBody2D    Node2D    down    unique_name_in_owner 	   position    exclude_parent    target_position    hit_from_inside 
   RayCast2D    right    left    up    rayspos    remote_path    RemoteTransform2D    	   variants    	                         
         �A       
     �A    
     ��    
         ��                   node_count             nodes     _   ��������       ����                                  ����                     ����                     	      
                       ����                     	      
                       ����                     	      
                       ����                     	      
                        ����                   conn_count              conns               node_paths              editable_instances              version             RSRC    GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�m�m۬�}�p,��5xi�d�M���)3��$�V������3���$G�$2#�Z��v{Z�lێ=W�~� �����d�vF���h���ڋ��F����1��ڶ�i�엵���bVff3/���Vff���Ҿ%���qd���m�J�}����t�"<�,���`B �m���]ILb�����Cp�F�D�=���c*��XA6���$
2#�E.@$���A.T�p )��#L��;Ev9	Б )��D)�f(qA�r�3A�,#ѐA6��npy:<ƨ�Ӱ����dK���|��m�v�N�>��n�e�(�	>����ٍ!x��y�:��9��4�C���#�Ka���9�i]9m��h�{Bb�k@�t��:s����¼@>&�r� ��w�GA����ը>�l�;��:�
�wT���]�i]zݥ~@o��>l�|�2�Ż}�:�S�;5�-�¸ߥW�vi�OA�x��Wwk�f��{�+�h�i�
4�˰^91��z�8�(��yޔ7֛�;0����^en2�2i�s�)3�E�f��Lt�YZ���f-�[u2}��^q����P��r��v��
�Dd��ݷ@��&���F2�%�XZ!�5�.s�:�!�Њ�Ǝ��(��e!m��E$IQ�=VX'�E1oܪì�v��47�Fы�K챂D�Z�#[1-�7�Js��!�W.3׹p���R�R�Ctb������y��lT ��Z�4�729f�Ј)w��T0Ĕ�ix�\�b�9�<%�#Ɩs�Z�O�mjX �qZ0W����E�Y�ڨD!�$G�v����BJ�f|pq8��5�g�o��9�l�?���Q˝+U�	>�7�K��z�t����n�H�+��FbQ9���3g-UCv���-�n�*���E��A�҂
�Dʶ� ��WA�d�j��+�5�Ȓ���"���n�U��^�����$G��WX+\^�"�h.���M�3�e.
����MX�K,�Jfѕ*N�^�o2��:ՙ�#o�e.
��p�"<W22ENd�4B�V4x0=حZ�y����\^�J��dg��_4�oW�d�ĭ:Q��7c�ڡ��
A>��E�q�e-��2�=Ϲkh���*���jh�?4�QK��y@'�����zu;<-��|�����Y٠m|�+ۡII+^���L5j+�QK]����I �y��[�����(}�*>+���$��A3�EPg�K{��_;�v�K@���U��� gO��g��F� ���gW� �#J$��U~��-��u���������N�@���2@1��Vs���Ŷ`����Dd$R�":$ x��@�t���+D�}� \F�|��h��>�B�����B#�*6��  ��:���< ���=�P!���G@0��a��N�D�'hX�׀ "5#�l"j߸��n������w@ K�@A3�c s`\���J2�@#�_ 8�����I1�&��EN � 3T�����MEp9N�@�B���?ϓb�C��� � ��+�����N-s�M�  ��k���yA 7 �%@��&��c��� �4�{� � �����"(�ԗ�� �t�!"��TJN�2�O~� fB�R3?�������`��@�f!zD��%|��Z��ʈX��Ǐ�^�b��#5� }ى`�u�S6�F�"'U�JB/!5�>ԫ�������/��;	��O�!z����@�/�'�F�D"#��h�a �׆\-������ Xf  @ �q�`��鎊��M��T�� ���0���}�x^�����.�s�l�>�.�O��J�d/F�ě|+^�3�BS����>2S����L�2ޣm�=�Έ���[��6>���TъÞ.<m�3^iжC���D5�抺�����wO"F�Qv�ږ�Po͕ʾ��"��B��כS�p�
��E1e�������*c�������v���%'ž��&=�Y�ް>1�/E������}�_��#��|������ФT7׉����u������>����0����緗?47�j�b^�7�ě�5�7�����|t�H�Ե�1#�~��>�̮�|/y�,ol�|o.��QJ rmϘO���:��n�ϯ�1�Z��ը�u9�A������Yg��a�\���x���l���(����L��a��q��%`�O6~1�9���d�O{�Vd��	��r\�՜Yd$�,�P'�~�|Z!�v{�N�`���T����3?DwD��X3l �����*����7l�h����	;�ߚ�;h���i�0�6	>��-�/�&}% %��8���=+��N�1�Ye��宠p�kb_����$P�i�5�]��:��Wb�����������ě|��[3l����`��# -���KQ�W�O��eǛ�"�7�Ƭ�љ�WZ�:|���є9�Y5�m7�����o������F^ߋ������������������Р��Ze�>�������������?H^����&=����~�?ڭ�>���Np�3��~���J�5jk�5!ˀ�"�aM��Z%�-,�QU⃳����m����:�#��������<�o�����ۇ���ˇ/�u�S9��������ٲG}��?~<�]��?>��u��9��_7=}�����~����jN���2�%>�K�C�T���"������Ģ~$�Cc�J�I�s�? wڻU���ə��KJ7����+U%��$x�6
�$0�T����E45������G���U7�3��Z��󴘶�L�������^	dW{q����d�lQ-��u.�:{�������Q��_'�X*�e�:�7��.1�#���(� �k����E�Q��=�	�:e[����u��	�*�PF%*"+B��QKc˪�:Y��ـĘ��ʴ�b�1�������\w����n���l镲��l��i#����!WĶ��L}rեm|�{�\�<mۇ�B�HQ���m�����x�a�j9.�cRD�@��fi9O�.e�@�+�4�<�������v4�[���#bD�j��W����֢4�[>.�c�1-�R�����N�v��[�O�>��v�e�66$����P
�HQ��9���r�	5FO� �<���1f����kH���e�;����ˆB�1C���j@��qdK|
����4ŧ�f�Q��+�     [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://chuwdcemp7dpi"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
                RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    size    script 	   _bundled       PackedScene    res://spike.tscn �o]3(!   PackedScene    res://head.tscn �P�7      local://RectangleShape2D_gu2xr �         local://RectangleShape2D_ag8ak �         local://PackedScene_r8m2o          RectangleShape2D       
    `D  �B         RectangleShape2D       
      B   B         PackedScene          	         names "         Node2D    Spike 	   position    StaticBody2D    CollisionShape2D    shape    CollisionShape2D2    CollisionShape2D3    CollisionShape2D4    head 	   modulate 
   ColorRect    offset_top    offset_right    offset_bottom    ColorRect2    offset_left    ColorRect3    ColorRect4    	   variants                 
     �C ��C
    `�C  �C          
     JC ��C         
     JC ��C
     �C ��C         
     �B  �C   c�T>& �: �>  �?    ��C    �D    @
D     5C     �C     ^C    ��C    ��C    ��C     �C     �C     6C     sC     _C     �C      node_count             nodes     �   ��������        ����                ���                                  ����                     ����                                ����                                ����                                ����                           ���	            	                       ����   
   
                    ����                                      ����                                            ����                                            ����                                     conn_count              conns               node_paths              editable_instances              version             RSRC     extends Area2D
 RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    size    script 	   _bundled       Script    res://spike.gd ��������      local://RectangleShape2D_isaqp Q         local://PackedScene_uqlnm �         RectangleShape2D       
      A   A         PackedScene          	         names "         Spike    script    cut    Area2D    CollisionShape2D    shape    debug_color 
   ColorRect    offset_left    offset_top    offset_right    offset_bottom    color    _on_body_shape_entered    body_shape_entered    	   variants                                �?        =
�>     ��     �A     �?          �?      node_count             nodes     &   ��������       ����                              ����                                 ����         	      
                            conn_count             conns                                       node_paths              editable_instances              version             RSRC    extends CollisionShape2D



signal cut(ind)

var ind = -1


func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.is_in_group("cut")):
		cut.emit(ind)
 RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    size    script 	   _bundled       Script    res://tail.gd ��������      local://RectangleShape2D_8d52h {         local://RectangleShape2D_ard08 �         local://PackedScene_lfosx �         RectangleShape2D       
     B  B         RectangleShape2D       
     B  B         PackedScene          	         names "         tail    shape    script    CollisionShape2D 
   ColorRect    offset_left    offset_top    offset_right    offset_bottom    Area2D    visible    _on_area_2d_area_entered    area_entered    	   variants                                ��     �A                      node_count             nodes     ,   ��������       ����                                  ����                                       	   	   ����   
                       ����                   conn_count             conns                                      node_paths              editable_instances              version             RSRC[remap]

path="res://.godot/exported/133200997/export-cd8ca12872c88409033478bd9c5705a5-deadbody.scn"
           [remap]

path="res://.godot/exported/133200997/export-08bd25e3251a4adb1288a88c1d8cc503-fall.scn"
               [remap]

path="res://.godot/exported/133200997/export-c6126d1cbebe690335fabb9cc27c1427-head.scn"
               [remap]

path="res://.godot/exported/133200997/export-362256a061aa8890e9a1e558b11e5ec3-node_2d.scn"
            [remap]

path="res://.godot/exported/133200997/export-65a124e7c268d791d04f413a6d11990a-spike.scn"
              [remap]

path="res://.godot/exported/133200997/export-4fe1464105c47ebb93ca2be69ccaeb47-tail.scn"
               list=Array[Dictionary]([])
     <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 814 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H446l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z" fill="#478cbf"/><path d="M483 600c0 34 58 34 58 0v-86c0-34-58-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
              �Ѕ�%݃   res://deadbody.tscny�K=S   res://fall.tscn�P�7   res://head.tscn ��E��I   res://icon.svgL�p���H   res://node_2d.tscn�o]3(!   res://spike.tscn���9�m   res://tail.tscn        ECFG      application/config/name         gmtk   application/run/main_scene         res://node_2d.tscn     application/config/features$   "         4.2    Forward Plus       application/config/icon         res://icon.svg     input/right0              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   D   	   key_label             unicode    d      echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script      
   input/left0              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   A   	   key_label             unicode    a      echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script         input/up0              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   W   	   key_label             unicode    w      echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script      
   input/down0              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode   S   	   key_label             unicode    s      echo          script            InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script                