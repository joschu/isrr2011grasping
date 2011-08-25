import bpy
from mathutils import Vector
PI = 3.141592

def add_sphere(location,size):
    bpy.ops.mesh.primitive_uv_sphere_add(segments=32, ring_count=16, size=size, view_align=False, enter_editmode=False, location=location, rotation=(0, 0, 0), layers=(True, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False))
def add_cylinder(location,rotation,radius,depth):
    bpy.ops.mesh.primitive_cylinder_add(vertices=32, radius=radius, depth=depth, cap_ends=True, view_align=False, enter_editmode=False, location=location, rotation=rotation, layers=(True, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False))
def add_empty(location):
    bpy.ops.object.add(type='EMPTY', view_align=False, enter_editmode=False, location=location, rotation=(0, 0, 0), layers=(True, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False))

def add_pole(end,ray,length,r,backup):
    vray = Vector(ray)
    vray.normalize()
    vend = Vector(end)
    center = vend - vray*(length/2+r+backup)
    ang = Vector((0,0,1)).rotation_difference(vray).to_euler()
    add_cylinder(center,ang,r,length)
    cyl_name = get_last_object('Cylinder')
    add_sphere(vend-(r+backup)*vray,r)
    sph_name = get_last_object('Sphere')
    bpy.ops.object.select_pattern(pattern=cyl_name,extend=False)
    bpy.ops.object.select_pattern(pattern=sph_name,extend=True)    
    bpy.ops.object.join()
    return sph_name
    
def move_poles(vecs):
    names = get_objs('Sphere')
    assert len(names) == len(vecs)
    for (name,vec) in zip(names,vecs):
        bpy.ops.object.select_pattern(pattern=name,extend=False)
        bpy.ops.transform.translate(value=vec)
def animate_poles1(vecs):
    bpy.ops.anim.change_frame(frame=0)
    backup = 1.5
    v1 = Vector((1,0,0))
    v2 = Vector((0,1,0))
    vecs = [v1,v2]
    for vec in vecs: add_pole((0,0,0),vec,3,.1,1.5)    
    bpy.ops.object.select_pattern(pattern='Sphere*',extend=False)    
    bpy.ops.anim.keyframe_insert(type='Location')

    names = get_objs('Sphere')
    bpy.ops.anim.change_frame(frame=24)
    for (name,vec) in zip(names,vecs):
        bpy.ops.object.select_pattern(pattern=name,extend=False)
        bpy.ops.transform.translate(value=vec*backup)            
        bpy.ops.anim.keyframe_insert(type='Location')

def draw_spheres(cents,r):
    for cent in cents:
        add_sphere(cent,r)
        
def animate_poles(ends,rays,length,r,backup):
    bpy.ops.anim.change_frame(frame=0)
    for (end,ray) in zip(ends,rays): 
        add_pole(end,ray,length,r,backup)    
    bpy.ops.object.select_pattern(pattern='Sphere*',extend=False)    
    bpy.ops.anim.keyframe_insert(type='Location')

    names = get_objs('Sphere')
    bpy.ops.anim.change_frame(frame=24)
    for (name,vec) in zip(names,rays):
        bpy.ops.object.select_pattern(pattern=name,extend=False)
        bpy.ops.transform.translate(value=Vector(vec)*backup)            
        bpy.ops.anim.keyframe_insert(type='Location')
        
        
def rotate(angle,axis):
    bpy.ops.transform.rotate(value=(angle,), axis=axis, constraint_axis=(False, False, True), constraint_orientation='GLOBAL', mirror=False, proportional='DISABLED', proportional_edit_falloff='SMOOTH', proportional_size=1, snap=False, snap_target='CLOSEST', snap_point=(0, 0, 0), snap_align=False, snap_normal=(0, 0, 0), release_confirm=False)
  
def read_var_file(fname):
    with open(fname,'r') as fh: lines = fh.readlines()
    name_inds,names = zip(*[(i_line,line[1:].strip()) 
                         for (i_line,line) in enumerate(lines)
                         if line.startswith('#')])
    starts = [ind+1 for ind in name_inds]
    ends = [ind for ind in name_inds[1:]] + [len(lines)]
    name2val = {}
    for (start,end,name) in zip(starts,ends,names):
        name2val[name] = [list(map(float,line.split())) for line in lines[start:end]]    
    return name2val
    
    
    
        
def translate_along_ray(obj_name,ray,len):
    pass    
def get_last_object(name):
    return get_objs(name)[-1]
def get_objs(name):
    return [key for key in bpy.data.objects.keys() if key.startswith(name)]    
    
def spin():
    bpy.ops.object.select_pattern(pattern='Empty*',extend=False)    
    
    bpy.ops.anim.change_frame(frame=24)
    bpy.ops.anim.keyframe_insert(type='Rotation')
    
    bpy.ops.anim.change_frame(frame=32)    
    rotate(angle=2*PI/3,axis=(0,0,1))    
    bpy.ops.anim.keyframe_insert(type='Rotation')
    
    bpy.ops.anim.change_frame(frame=40)    
    rotate(angle=2*PI/3,axis=(0,0,1))
    bpy.ops.anim.keyframe_insert(type='Rotation')

    bpy.ops.anim.change_frame(frame=48)    
    rotate(angle=2*PI/3,axis=(0,0,1))
    bpy.ops.anim.keyframe_insert(type='Rotation')

def rotate_mesh():
    bpy.ops.object.select_pattern(pattern='Mesh',extend=False)
    bpy.ops.transform.rotate(value=(PI/2,), axis=(-1, 0, -0), constraint_axis=(False, False, False), constraint_orientation='GLOBAL', mirror=False, proportional='DISABLED', proportional_edit_falloff='SMOOTH', proportional_size=1, snap=False, snap_target='CLOSEST', snap_point=(0, 0, 0), snap_align=False, snap_normal=(0, 0, 0), release_confirm=False)
    
def select_shapes():
    bpy.ops.object.select_pattern(pattern='Mesh',extend=False)
    bpy.ops.object.select_pattern(pattern='Sphere*',extend=True)    
    
def make_empty(shape_center):
    add_empty(shape_center)
    bpy.ops.object.select_pattern(pattern='Empty',extend=False)    
    bpy.ops.object.select_pattern(pattern='Camera',extend=True)
    bpy.ops.object.parent_set(type='OBJECT')
    
def the_whole_shebang(fname):
    d = read_var_file(fname)
    #rotate_mesh()
    animate_poles(d['centers'],d['rays'],d['length'][0][0],d['r'][0][0],d['backup'][0][0])
    make_empty(d['shape_center'][0])
    spin()
    select_shapes()
    #draw_spheres(d['all_centers'],d['r'][0][0])

    
if __name__ == '__main__':
    with open('../current_object_info.m','r') as fh: text = fh.read()
    exec(text) # desc, fname
    info_file = '%s_info.txt'%desc
    the_whole_shebang(info_file)
    #make_empty()
    #spin()
    #animate_poles()
