part of '../../../rest_debug_screen.dart';

class _DioRequestInfoSection extends StatelessWidget {
  final ApiLogData info;
  final bool showToken;

  const _DioRequestInfoSection({
    super.key,
    required this.info,
    required this.showToken,
  });

  @override
  Widget build(BuildContext context) {
    const double iconSize = 18;
    return _CustomAppContainer(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconLabelText(
            icon: const Icon(
              Icons.language,
              size: iconSize,
            ),
            label: 'Base URL: ',
            text: info.requestLogData.baseUrl,
          ),
          const SizedBox(height: 10),
          IconLabelText(
            icon: const Icon(
              Icons.link,
              size: iconSize,
            ),
            label: 'Path: ',
            text: info.requestLogData.uri.path,
          ),
          const SizedBox(height: 10),
          IconLabelText(
            icon: const Icon(
              Icons.tonality_outlined,
              size: iconSize,
            ),
            label: 'Method:',
            text: info.requestLogData.method,
          ),
          if (info.token != null) const SizedBox(height: 10),
          if (info.token != null)
            IconLabelText(
              icon: const Icon(
                Icons.token,
                size: iconSize,
              ),
              label: 'Token: ',
              text: showToken ? info.token! : '[Not Show]',
              suffixIcon: SimpleSmallIconButton(
                iconData: Icons.copy,
                onPressed: showToken
                    ? () {
                        Clipboard.setData(ClipboardData(text: info.token!));
                        _closeAllSnackBars(context);
                        _showSnackBar(
                          context,
                          "Copied",
                        );
                      }
                    : null,
              ),
            ),
          if (info.responseLogData != null &&
              info.responseLogData!.responseHeaders.isNotEmpty)
            const SizedBox(height: 10),
          if (info.responseLogData != null &&
              info.responseLogData!.responseHeaders.isNotEmpty)
            const IconLabelText(
              icon: Icon(Icons.topic, size: iconSize),
              label: 'Headers:',
              text: '',
            ),
          if (info.responseLogData != null &&
              info.responseLogData!.responseHeaders.isNotEmpty)
            const SizedBox(height: 10),
          if (info.responseLogData != null &&
              info.responseLogData!.responseHeaders.isNotEmpty)
            _MapKeyValueView(map: info.responseLogData!.responseHeaders),
          //
          if (info.requestLogData.queryParameters.isNotEmpty)
            const SizedBox(height: 10),
          if (info.requestLogData.queryParameters.isNotEmpty)
            const IconLabelText(
              icon: Icon(Icons.color_lens_outlined, size: iconSize),
              label: 'Query Parameters:',
              text: '',
            ),
          if (info.requestLogData.queryParameters.isNotEmpty)
            const SizedBox(height: 10),
          if (info.requestLogData.queryParameters.isNotEmpty)
            _MapKeyValueView(map: info.requestLogData.queryParameters),
          //
          //
          if (info.requestLogData.mapData.isNotEmpty)
            const SizedBox(height: 10),
          if (info.requestLogData.mapData.isNotEmpty)
            const IconLabelText(
              icon: Icon(Icons.topic, size: iconSize),
              label: 'Data:',
              text: '',
            ),
          if (info.requestLogData.mapData.isNotEmpty)
            const SizedBox(height: 10),
          if (info.requestLogData.mapData.isNotEmpty)
            _MapKeyValueView(map: info.requestLogData.mapData),
        ],
      ),
    );
  }
}
