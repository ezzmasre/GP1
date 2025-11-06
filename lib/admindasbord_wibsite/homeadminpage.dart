import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wibsite/admindasbord_wibsite/adminlogin.dart';

class HomePageWeb extends StatelessWidget {
  const HomePageWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildNavBar(context), // Pass context here
            _buildHeroSection(),
            _buildAboutSection(),
            _buildFeaturesSection(),
            _buildTrainersHighlight(),
            _buildTestimonialsSection(),
            _buildCtaSection(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 20),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'FitFlow',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              _NavItem(title: 'Home', onTap: () {}),
              _NavItem(title: 'About', onTap: () {}),
              _NavItem(title: 'Services', onTap: () {}),
              _NavItem(title: 'Trainers', onTap: () {}),
              _NavItem(title: 'Contact', onTap: () {}),
              const SizedBox(width: 20),
              _AnimatedButton(
                title: 'Join Now',
                isPrimary: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Adminlogin()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 800,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const NetworkImage(
              'https://images.unsplash.com/photo-1534438327276-14e5300c3a48'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.darken,
          ),
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'SHAPE YOUR\nPERFECT BODY',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Train smarter, get stronger',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 24,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 50),
                _AnimatedButton(
                  title: 'START TODAY',
                  isPrimary: true,
                  onTap: () {},
                ),
              ],
            ),
          ),
          const Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StatItem(number: '500+', label: 'Members'),
                _StatItem(number: '50+', label: 'Programs'),
                _StatItem(number: '25+', label: 'Trainers'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 120),
      color: const Color(0xFF111111),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                'https://images.unsplash.com/photo-1571902943202-507ec2618e8f',
                height: 500,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 80),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ABOUT US',
                  style: TextStyle(
                    color: Color(0xFFD5FF5F),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'We Are Here To\nDream Together',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'At Gymster, we believe in transforming lives through fitness. Our state-of-the-art facilities and expert trainers are here to guide you on your journey to a healthier, stronger you.',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 18,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 40),
                _AnimatedButton(
                  title: 'Learn More',
                  isPrimary: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 120),
      color: Colors.black,
      child: const Column(
        children: [
          Text(
            'WHY CHOOSE US',
            style: TextStyle(
              color: Color(0xFFD5FF5F),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Our Features',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _FeatureCard(
                icon: Icons.fitness_center,
                title: 'Modern Equipment',
                description: 'State-of-the-art facilities with the latest fitness technology',
              ),
              _FeatureCard(
                icon: Icons.person,
                title: 'Expert Trainers',
                description: 'Professional coaches to guide your fitness journey',
              ),
              _FeatureCard(
                icon: Icons.schedule,
                title: 'Flexible Time',
                description: 'Open 24/7 to fit your busy schedule',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrainersHighlight() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 120),
      color: const Color(0xFF111111),
      child: Column(
        children: [
          const Text(
            'MEET OUR TEAM',
            style: TextStyle(
              color: Color(0xFFD5FF5F),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Expert Trainers',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _TrainerCard(
                name: 'John Smith',
                specialty: 'Strength & Conditioning',
                image: 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b', // Male trainer
                onTap: () {},
              ),
              _TrainerCard(
                name: 'Sarah Johnson',
                specialty: 'Nutrition Expert',
                image: 'https://images.unsplash.com/photo-1609899537878-9c2a4195048d',  // Female trainer
                onTap: () {},
              ),
              _TrainerCard(
                name: 'Mike Wilson',
                specialty: 'HIIT Specialist',
                image: 'https://images.unsplash.com/photo-1617874963673-dd5195102081',  // Male trainer
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 120),
      color: Colors.black,
      child: const Column(
        children: [
          Text(
            'TESTIMONIALS',
            style: TextStyle(
              color: Color(0xFFD5FF5F),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'What Our Clients Say',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TestimonialCard(
                name: 'Sarah M.',
                role: 'Member since 2023',
                text: 'Joining Gymster was the best decision I made for my fitness journey. The trainers are exceptional!',
                image: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80',  // Female testimonial
              ),
              SizedBox(width: 30),
              _TestimonialCard(
                name: 'John D.',
                role: 'Member since 2022',
                text: 'The facilities are top-notch and the community is incredibly supportive. Achieved my goals in record time!',
                image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',  // Male testimonial
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCtaSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 120),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const NetworkImage(
              'https://images.unsplash.com/photo-1599058917765-a780eda07a3e'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.7),
            BlendMode.darken,
          ),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'START YOUR JOURNEY TODAY',
            style: TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Join our community of fitness enthusiasts and transform your life',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AnimatedButton(
                title: 'GET STARTED',
                isPrimary: true,
                onTap: () {},
              ),
              const SizedBox(width: 20),
              _AnimatedButton(
                title: 'LEARN MORE',
                isPrimary: false,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 120),
      color: const Color(0xFF111111),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'GYMSTER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: Text(
                      'Transform your body and mind with our expert-led fitness programs and state-of-the-art facilities.',
                      style: TextStyle(
                        color: Colors.grey[400],
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      _SocialIcon(icon: FontAwesomeIcons.facebook, onTap: () {}),
                      _SocialIcon(icon: FontAwesomeIcons.instagram, onTap: () {}),
                      _SocialIcon(icon: FontAwesomeIcons.twitter, onTap: () {}),
                    ],
                  ),
                ],
              ),
              const _FooterColumn(
                title: 'Quick Links',
                items: ['Home', 'About', 'Classes', 'Schedule', 'Contact'],
              ),
              const _FooterColumn(
                title: 'Membership',
                items: ['Pricing', 'Benefits', 'FAQ', 'Support'],
              ),
              const _FooterColumn(
                title: 'Contact Us',
                items: [
                  '123 Fitness Street',
                  'New York, NY 10001',
                  'info@gymster.com',
                  '+1 234 567 8900',
                ],
              ),
            ],
          ),
          const SizedBox(height: 60),
          const Divider(color: Colors.white24),
          const SizedBox(height: 20),
          Text(
            '© 2024 Gymster. All rights reserved.',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

// Helper Widgets
class _NavItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const _NavItem({required this.title, required this.onTap});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: TextButton(
        onPressed: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            widget.title,
            style: TextStyle(
              color: isHovered ? const Color(0xFFD5FF5F) : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedButton extends StatefulWidget {
  final String title;
  final bool isPrimary;
  final VoidCallback onTap;

  const _AnimatedButton({
    required this.title,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..translate(0, isHovered ? -5 : 0),
        child: ElevatedButton(
          onPressed: widget.onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                widget.isPrimary ? const Color(0xFFD5FF5F) : Colors.transparent,
            foregroundColor: widget.isPrimary ? Colors.black : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            side:
                widget.isPrimary ? null : const BorderSide(color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _TrainerCard extends StatefulWidget {
  final String name;
  final String specialty;
  final String image;
  final VoidCallback onTap;

  const _TrainerCard({
    required this.name,
    required this.specialty,
    required this.image,
    required this.onTap,
  });

  @override
  State<_TrainerCard> createState() => _TrainerCardState();
}

class _TrainerCardState extends State<_TrainerCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..translate(0, isHovered ? -10 : 0),
          child: Container(
            width: 280,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2E),
              borderRadius: BorderRadius.circular(20),
              boxShadow: isHovered
                  ? [
                      BoxShadow(
                        color: const Color(0xFFD5FF5F).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ]
                  : null,
            ),
            child: Column(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    image: DecorationImage(
                      image: NetworkImage(widget.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.specialty,
                        style: const TextStyle(
                          color: Color(0xFFD5FF5F),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SocialIcon(icon: Icons.facebook, onTap: () {}),
                          _SocialIcon(icon: Icons.photo_camera, onTap: () {}),
                          _SocialIcon(
                              icon: Icons.alternate_email, onTap: () {}),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialIcon({required this.icon, required this.onTap});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isHovered ? const Color(0xFFD5FF5F) : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFD5FF5F)),
          ),
          child: Icon(
            widget.icon,
            color: isHovered ? Colors.black : const Color(0xFFD5FF5F),
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String number;
  final String label;

  const _StatItem({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Text(
            number,
            style: const TextStyle(
              color: Color(0xFFD5FF5F),
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(30),
        width: 300,
        decoration: BoxDecoration(
          color: isHovered ? const Color(0xFF1A1A1E) : const Color(0xFF111111),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isHovered ? const Color(0xFFD5FF5F) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              widget.icon,
              color: const Color(0xFFD5FF5F),
              size: 50,
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TestimonialCard extends StatefulWidget {
  final String name;
  final String role;
  final String text;
  final String image;

  const _TestimonialCard({
    required this.name,
    required this.role,
    required this.text,
    required this.image,
  });

  @override
  State<_TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<_TestimonialCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(30),
        width: 400,
        decoration: BoxDecoration(
          color: isHovered ? const Color(0xFF1A1A1E) : const Color(0xFF111111),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isHovered ? const Color(0xFFD5FF5F) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(widget.image),
            ),
            const SizedBox(height: 20),
            Text(
              widget.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.role,
              style: const TextStyle(
                color: Color(0xFFD5FF5F),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> items;

  const _FooterColumn({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                item,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
              ),
            )),
      ],
    );
  }
}