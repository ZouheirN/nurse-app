import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nurse_app/components/loader.dart';
import 'package:nurse_app/extensions/context_extension.dart';
import 'package:nurse_app/features/home/cubit/home_cubit.dart';

class Faq extends StatefulWidget {
  const Faq({super.key});

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  final _faqCubit = HomeCubit();

  @override
  void initState() {
    _faqCubit.getFaqs(isAdmin: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.localizations.fAQs,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontStyle: FontStyle.italic,
            fontSize: 20,
          ),
        ),
        BlocBuilder<HomeCubit, HomeState>(
          bloc: _faqCubit,
          builder: (context, state) {
            if (state is GetFaqsLoading) {
              return const Loader();
            } else if (state is GetFaqsSuccess) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var faq in state.faqs.data) _buildTile(
                    faq.question.toString(), faq.answer.toString(),),
                ],
              );
            } else if (state is GetFaqsFailure) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        // _buildTile(context.localizations.faq1, context.localizations.faq1Body),
        // _buildTile(context.localizations.faq2, context.localizations.faq2Body),
        // _buildTile(context.localizations.faq3, context.localizations.faq3Body),
      ],
    );
  }

  _buildTile(String title, String body) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: ListTileTheme(
        tileColor: const Color(0xFF7BB442),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ExpansionTile(
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: Color.fromARGB(255, 209, 209, 209),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  body,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
