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
    const double iconSize = 18;
    return _CustomAppContainer(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconLabelText(
              icon: const Icon(
                Icons.language,
                size: iconSize,
              ),
              label: 'Base URL: ',
              text: apiLogData.requestLogData.baseUrl,
            ),
            const SizedBox(height: 10),
            IconLabelText(
              icon: const Icon(
                Icons.link,
                size: iconSize,
              ),
              label: 'Path: ',
              text: apiLogData.requestLogData.uri.path,
            ),
            const SizedBox(height: 10),
            IconLabelText(
              icon: const Icon(
                Icons.tonality_outlined,
                size: iconSize,
              ),
              label: 'Method: ',
              text: apiLogData.requestLogData.method,
            ),
            if (apiLogData.authorization != null) const SizedBox(height: 10),
            if (apiLogData.authorization != null)
              IconLabelText(
                icon: const Icon(
                  Icons.token,
                  size: iconSize,
                ),
                label: 'Authorization: ',
                text: showAuthorization
                    ? apiLogData.authorization!
                    : '[Not Show]',
                suffixIcon: SimpleSmallIconButton(
                  iconData: Icons.copy,
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
                icon: Icon(Icons.color_lens_outlined, size: iconSize),
                label: 'Query Parameters:',
                text: '',
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
                icon: Icon(Icons.topic, size: iconSize),
                label: 'Data: ',
                text: '',
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
}
