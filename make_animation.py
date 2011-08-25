#print('hji')
def add_sphere(location,size):
    bpy.ops.mesh.primitive_uv_sphere_add(segments=32, ring_count=16, size=size, view_align=False, enter_editmode=False, location=location, rotation=(0, 0, 0), layers=(True, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False))
def add_cylinder(location,rotation,size):
    bpy.ops.mesh.primitive_uv_sphere_add(segments=32, ring_count=16, size=size, view_align=False, enter_editmode=False, location=location, rotation=rotation, layers=(True, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False))
    
