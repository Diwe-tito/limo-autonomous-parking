from setuptools import find_packages, setup

package_name = 'limo_project_bringup'

setup(
    name=package_name,
    version='0.0.0',
    packages=find_packages(exclude=['test']),
    data_files=[
    ('share/ament_index/resource_index/packages',
        ['resource/limo_project_bringup']),
    ('share/limo_project_bringup', ['package.xml']),
    ('share/limo_project_bringup/launch', ['launch/sim_robot.launch.py']),
],

    install_requires=['setuptools'],
    zip_safe=True,
    maintainer='tito',
    maintainer_email='tito@todo.todo',
    description='TODO: Package description',
    license='TODO: License declaration',
    extras_require={
        'test': [
            'pytest',
        ],
    },
    entry_points={
        'console_scripts': [
        ],
    },
)
