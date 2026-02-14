part of '../../../rest_debug_screen.dart';

class _DioRequestInfoSection extends StatelessWidget {
  final ApiLogData apiLogData;
  final bool showAuthorization;

  const _DioRequestInfoSection({
    super.key,
    required this.apiLogData,
    required this.showAuthorization,
  });

  @override
  Widget build(BuildContext context) {
    return _CustomAppContainer(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconLabelSelectableText(
              icon: const Icon(
                Icons.language,
                size: defaultIconSize,
              ),
              label: 'Base URL: ',
              text: apiLogData.requestLogData.baseUrl,
              labelStyle: defaultLabelStyle,
              textStyle: defaultTextStyle,
            ),
            const SizedBox(height: 10),
            IconLabelSelectableText(
              icon: const Icon(
                Icons.link,
                size: defaultIconSize,
              ),
              label: 'Path: ',
              text: apiLogData.requestLogData.uri.path,
              labelStyle: defaultLabelStyle,
              textStyle: defaultTextStyle,
            ),
            const SizedBox(height: 10),
            IconLabelSelectableText(
              icon: const Icon(
                Icons.tonality_outlined,
                size: defaultIconSize,
              ),
              label: 'Method: ',
              text: apiLogData.requestLogData.method,
              labelStyle: defaultLabelStyle,
              textStyle: defaultTextStyle,
            ),
            if (apiLogData.authorization != null) const SizedBox(height: 10),
            if (apiLogData.authorization != null)
              IconLabelSelectableText(
                icon: const Icon(
                  Icons.token,
                  size: defaultIconSize,
                ),
                label: 'Authorization: ',
                text: showAuthorization
                    ? _truncate(apiLogData.authorization!, 30)
                    : '[Not Show]',
                labelStyle: defaultLabelStyle,
                textStyle: defaultTextStyle,
                suffixIcon: SimpleSmallIconButton(
                  iconData: Icons.copy,
                  iconSize: defaultIconSize,
                  onPressed: showAuthorization
                      ? () {
                          Clipboard.setData(
                              ClipboardData(text: apiLogData.authorization!));
                          _closeAllSnackBars(context);
                          _showSnackBar(
                            context,
                            "Copied",
                          );
                        }
                      : null,
                ),
              ),
            //
            if (apiLogData.requestLogData.queryParameters.isNotEmpty)
              const SizedBox(height: 10),
            if (apiLogData.requestLogData.queryParameters.isNotEmpty)
              const IconLabelText(
                icon: Icon(Icons.color_lens_outlined, size: defaultIconSize),
                label: 'Query Parameters:',
                text: '',
                labelStyle: defaultLabelStyle,
                textStyle: defaultTextStyle,
              ),
            if (apiLogData.requestLogData.queryParameters.isNotEmpty)
              const SizedBox(height: 10),
            if (apiLogData.requestLogData.queryParameters.isNotEmpty)
              _MapKeyValueView(map: apiLogData.requestLogData.queryParameters),
            //
            //
            if (apiLogData.requestLogData.mapData.isNotEmpty)
              const SizedBox(height: 10),
            if (apiLogData.requestLogData.mapData.isNotEmpty)
              const IconLabelText(
                icon: Icon(Icons.topic, size: defaultIconSize),
                label: 'Data: ',
                text: '',
                labelStyle: defaultLabelStyle,
                textStyle: defaultTextStyle,
              ),
            if (apiLogData.requestLogData.mapData.isNotEmpty)
              const SizedBox(height: 10),
            if (apiLogData.requestLogData.mapData.isNotEmpty)
              _MapKeyValueView(map: apiLogData.requestLogData.mapData),
          ],
        ),
      ),
    );
  }

  String _truncate(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return "${text.substring(0, maxLength)}...";
  }
}
